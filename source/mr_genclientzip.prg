* ! * mr_genclientzip

lparameters piguid, doplainzip

local blpath, instancefolder, lnx, nselect, skipfile, zipbasefolder, zipfilename, zfilepath

m.nselect = select()

if not used('inst_giz')

	use 'mr_instances' again alias 'inst_giz' in 0

endif

if seek(m.piguid, 'inst_giz', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	use in 'inst_giz'

	_restorearea(m.nselect)

	return

endif

if empty(inst_giz.izipfolder)

	messagebox('ERROR: INSTANCE OUTPUT ZIP FOLDER NOT SPECIFIED', 64, 'MODROBOT')

	use in 'inst_giz'

	_restorearea(m.nselect)

	return

endif

* ! * MULTIMC INSTANCE

if not used('blacklist_giz')

	use 'mr_blacklist' again alias 'blacklist_giz' in 0

endif

m.instancefolder = mr_getinstancefolderfrommodsfolder(inst_giz.ifolder)

m.zipbasefolder = justpath(m.instancefolder)

m.zipfilename = inst_giz.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + '.zip'

_logwrite('GENERATE MULTIMC INSTANCE ZIP START')

_logwrite('SOURCE FOLDER:', m.instancefolder)

_logwrite('ZIP FILE:', m.zipfilename)

_findfilesinfoldertree(m.instancefolder, '*.*')

_zipopen()

select 'foundfiles'

scan

	m.skipfile = .f.

	m.zfilepath = _zipgetzfilepath(foundfiles.filename, m.zipbasefolder)

	* ! * ADD SPECIAL FILES INSIDE "MODPACK" FOLDER

	if m.instancefolder + '\.minecraft\modpack' $ foundfiles.filename and m.doplainzip = .f.

		if foundfiles.filefolder = .f.

			_zipaddfile(foundfiles.filename, strtran(m.zfilepath, '\.minecraft\modpack\', '\', 1, 1, 1))

		endif

	endif

	select 'blacklist_giz'

	m.blpath = ''

	for m.lnx = 2 to getwordcount(m.zfilepath, '\')

		m.blpath = ltrim(m.blpath + '\' + getwordnum(m.zfilepath, m.lnx, '\'), 1, '\')

		?m.blpath
		
		locate for blacklist_giz.blpath == m.blpath

		if found('blacklist_giz') and blacklist_giz.blblack = .t.

			m.skipfile = .t.

			exit

		endif

	endfor

	if m.doplainzip = .t.

		m.skipfile = .f.

	endif

	if m.skipfile = .f.

		if foundfiles.filefolder = .t.

			m.zfilepath = addbs(m.zfilepath)

		endif

		*_logwrite(m.zfilepath)

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endif

endscan

_zipclose(m.zipfilename)

_logwrite('GENERATE MULTIMC INSTANCE ZIP END:', m.zipfilename)

use in 'inst_giz'

if used('blacklist_giz')

	use in 'blacklist_giz'

endif

_restorearea(m.nselect)