* ! * mr_genclientzip

lparameters piguid

*!* GENERATE BATCH FILES FIRST

Local blmd5, blpath, btext, crlf, installmodscmd, installmodssh, instancefolder, itext, nselect
Local skipfile, url, zfilepath, zipbasefolder, zipfilename

m.nselect = select()

if not used('inst_gcb')

	use 'mr_instances' again alias 'inst_gcb' in 0

endif

if seek(m.piguid, 'inst_gcb', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	use in 'inst_gcb'

	_restorearea(m.nselect)

	return

endif

if not used('batch_gcb')

	use 'mr_batch' again alias 'batch_gcb' in 0

endif

if not used('mods_gcb')

	use 'mr_mods' again alias 'mods_gcb' in 0 ORDER TAG 'filename1'

endif

if not used('files_gcb')

	use 'mr_files' again alias 'files_gcb' in 0

endif

_logwrite('GENERATE MULTIMC ZIP START')

m.crlf = 0h0d0a

select 'batch_gcb'

scan

	m.btext = batch_gcb.bmodheader + m.crlf

	select 'mods_gcb'

	scan for mods_gcb.iguid == m.piguid

		if mods_gcb.fid1 > 0

			if seek(mods_gcb.fid1, 'files_gcb', 'fid') = .f.

				_logwrite('FILEID NOT FOUND ERROR', mods_gcb.filename1)

				loop

			endif

			m.url = mr_geturlfile1(files_gcb.fid, files_gcb.filename)

			_logwrite('ADD FILE', files_gcb.fid, mods_gcb.filename1)

			*!* FIX URLS FOR WINDOWS BATCH

			if batch_gcb.buself = .f.

				m.url = strtran(m.url, '%', '%%')

			endif

			m.itext	= batch_gcb.bmoditem
			m.itext	= strtran(m.itext, '[MOD_FILENAME]', mods_gcb.filename1)
			m.itext	= strtran(m.itext, '[MOD_FILEURL]', m.url)

			m.btext = m.btext + m.itext + m.crlf

		endif

	endscan

	m.btext = m.btext + batch_gcb.bmodfooter + m.crlf

	if batch_gcb.buself = .t.

		m.btext = strtran(m.btext, 0h0d0a, 0h0a)

		m.installmodssh = m.btext

	else

		m.installmodscmd = m.btext

	endif

endscan

use in 'mods_gcb'

use in 'files_gcb'

use in 'batch_gcb'

use in 'inst_gcb'

_restorearea(m.nselect)

*!* NOW GENERATE ZIP FILE

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

*!* MULTIMC INSTANCE

if not used('blacklist_giz')

	use 'mr_blacklist' again alias 'blacklist_giz' in 0

endif

select 'blacklist_giz'

set filter to blacklist_giz.iguid == m.piguid

m.instancefolder = mr_getinstancefolderfrommodsfolder(inst_giz.ifolder)

m.zipbasefolder = justpath(m.instancefolder)

if empty(inst_giz.iname)

	m.zipfilename = inst_giz.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + '_multimc.zip'

else

	m.zipfilename = _cleanfilename(inst_giz.izipfolder + lower(chrtran(inst_giz.iname, ' ', '_')) + '_multimc.zip')

endif

_logwrite('SOURCE FOLDER:', m.instancefolder)

_logwrite('ZIP FILE:', m.zipfilename)

_zipopen()

*!* DELETE ANY LEFTOVER BATCH FILES (WE USED TO CREATE THE ACTUAL BATCH FILES IN THE INSTANCE FOLDER)

_apideletefile(m.instancefolder + '\.minecraft\_install_mods.cmd')

_apideletefile(m.instancefolder + '\.minecraft\_install_mods.sh')

*!* ADD THE ACTUAL BATCH FILES TO ZIP

_zipaddblob(m.installmodscmd, _zipgetzfilepath(m.instancefolder + '\.minecraft\_install_mods.cmd', m.zipbasefolder))

_zipaddblob(m.installmodssh, _zipgetzfilepath(m.instancefolder + '\.minecraft\_install_mods.sh', m.zipbasefolder))

*!* ADD FILES TO ZIP

_findfilesinfoldertree(m.instancefolder, '*.*')

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

	m.blpath = foundfiles.filename

	do while not lower(m.blpath) == lower(m.instancefolder)

		m.blmd5 = _md5hashstring(lower(m.blpath))

		if seek(m.blmd5, 'blacklist_giz', 'blmd5') = .t. and blacklist_giz.blblack = .t.

			m.skipfile = .t.

			exit

		endif

		m.blpath = justpath(m.blpath)

	enddo

	*!* check if we have a file inside the mods folder

	if foundfiles.filefolder = .f. and lower(justpath(foundfiles.filename)) == lower(inst_giz.ifolder)

		m.skipfile = .t.

	endif

	*!* add the file to the zip

	if m.skipfile = .f.

		if foundfiles.filefolder = .t.

			m.zfilepath = addbs(m.zfilepath)

		endif

		_logwrite('ADD FILE/FOLDER', m.zfilepath)

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endif

endscan

_zipclose(m.zipfilename)

*mr_rezipthezip(m.zipfilename)

_logwrite('GENERATE MULTIMC ZIP END')

use in 'inst_giz'

use in 'blacklist_giz'

_restorearea(m.nselect)  