* ! * mr_genclientzip

lparameters piguid

local blpath, instancefolder, lnx, modfilename, nselect, skipfile, zfilepath, zipbasefolder
local zipfilename

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

select 'blacklist_giz'

set filter to blacklist_giz.iguid == m.piguid

m.instancefolder = mr_getinstancefolderfrommodsfolder(inst_giz.ifolder)

m.zipbasefolder = justpath(m.instancefolder)

if empty(inst_giz.iname)

	m.zipfilename = inst_giz.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + '.zip'

else

	m.zipfilename = _cleanfilename(inst_giz.izipfolder + lower(chrtran(inst_giz.iname, ' ', '_')) + '_multimc.zip')

endif

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

	if m.instancefolder + '\.minecraft\modpack' $ foundfiles.filename

		if foundfiles.filefolder = .f.

			_zipaddfile(foundfiles.filename, strtran(m.zfilepath, '\.minecraft\modpack\', '\', 1, 1, 1))

		endif

	endif

	select 'blacklist_giz'

	m.blpath = ''

	for m.lnx = 2 to getwordcount(m.zfilepath, '\')

		m.blpath = ltrim(m.blpath + '\' + getwordnum(m.zfilepath, m.lnx, '\'), 1, '\')

		locate for blacklist_giz.blpath == m.blpath

		if found('blacklist_giz') and blacklist_giz.blblack = .t.

			m.skipfile = .t.

			exit

		endif

	endfor

	*!* check if we have a file inside the mods folder

	if foundfiles.filefolder = .f. and lower(justpath(foundfiles.filename)) == lower(inst_giz.ifolder)

		m.skipfile = .t.

	endif

	*!* add the file to the zip

	if m.skipfile = .f.

		if foundfiles.filefolder = .t.

			m.zfilepath = addbs(m.zfilepath)

		endif

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endif

endscan

*!* now scan instance mods and add jars that have no cf id

if not used('mods_giz')

	use 'mr_mods' again alias 'mods_giz' in 0

endif

select 'mods_giz'

scan for mods_giz.iguid = m.piguid

	*!* if the file has no cf id then add it to the zip

	if mods_giz.fid1 = 0

		m.modfilename = addbs(inst_giz.ifolder) + mods_giz.filename1

		if _file(m.modfilename)

			m.zfilepath = _zipgetzfilepath(m.modfilename, m.zipbasefolder)

			_zipaddfile(m.modfilename, m.zfilepath)

		endif

	endif

endscan

_zipclose(m.zipfilename)

_logwrite('GENERATE MULTIMC INSTANCE ZIP END:')

use in 'inst_giz'

use in 'blacklist_giz'

use in 'mods_giz'

_restorearea(m.nselect)