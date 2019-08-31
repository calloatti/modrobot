*!* mr_genserverfolder

lparameters piguid

local btext, crlf, filesource, filetarget, foldersource, foldertarget, itext, nselect
local result, txt, url

m.nselect = select()

if not used('inst_gsf')

	use 'mr_instances' again alias 'inst_gsf' in 0

endif

if seek(m.piguid, 'inst_gsf', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	use in 'inst_gsf'

	_restorearea(m.nselect)

	return

endif

if  empty(inst_gsf.isrvfolder)

	messagebox('ERROR: INSTANCE SERVER FOLDER IS EMPTY', 64, 'MODROBOT')

	use in 'inst_gsf'

	_restorearea(m.nselect)

	return

endif

if not used('batch_gsf')

	use 'mr_batch' again alias 'batch_gsf' in 0

endif

if not used('mods_gsf')

	use 'mr_mods' again alias 'mods_gsf' in 0 order tag 'filename1'

endif

if not used('modids_gsf')

	use 'mr_modids' again alias 'modids_gsf' in 0

endif

if not used('files_gsf')

	use 'mr_files' again alias 'files_gsf' in 0

endif

m.crlf = 0h0d0a

_logwrite('GENERATE SERVER INSTANCE START', inst_gsf.isrvfolder)

*!* COPY MODS OR ADD TO INSTALLMODS BATCH

m.txt = 'set curlparams=--fail --insecure --progress-bar --location' + m.crlf + m.crlf

m.foldersource = addbs(inst_gsf.ifolder)

m.foldertarget = rtrim(inst_gsf.isrvfolder, 1, '\')

_apicreatedirectory(m.foldertarget, 0)

m.foldertarget = addbs(inst_gsf.isrvfolder) + 'mods'

_deletefolder(m.foldertarget, _vfp.hwnd, 0)

_apicreatedirectory(m.foldertarget, 0)

m.foldertarget = addbs(m.foldertarget)

select 'batch_gsf'

scan

	select 'mods_gsf'

	m.btext = batch_gsf.bmodheader + m.crlf

	scan for mods_gsf.iguid == m.piguid

		if lower(mods_gsf.env) == 'client'

			loop

		endif

		if seek(mods_gsf.modid, 'modids_gsf', 'modid') = .t. and modids_gsf.isclient = .t.

			loop

		endif

		if mods_gsf.fid1 = 0

			m.filesource = m.foldersource + mods_gsf.filename1

			m.filetarget = m.foldertarget + mods_gsf.filename1

			_logwrite('COPY MOD', m.filesource, m.filetarget)

			m.result = _apicopyfile(m.filesource, m.filetarget, 0)

			if m.result = 0

				_logwrite('COPY MOD ERROR', m.filesource)

			endif

			loop

		endif

		if seek(mods_gsf.fid1, 'files_gsf', 'fid') = .f.

			_logwrite('FILEID NOT FOUND ERROR', m.filesource)

			loop

		endif

		m.url = mr_geturlfile1(files_gsf.fid, files_gsf.filename)

		*!* FIX URLS FOR WINDOWS BATCH

		if batch_gsf.buself = .f.

			m.url = strtran(m.url, '%', '%%')

		endif

		m.itext	= batch_gsf.bmoditem
		m.itext	= strtran(m.itext, '[MOD_FILENAME]', mods_gsf.filename1)
		m.itext	= strtran(m.itext, '[MOD_FILEURL]', m.url)

		m.btext = m.btext + m.itext + m.crlf

	endscan

	m.btext = m.btext + batch_gsf.bmodfooter + m.crlf

	if batch_gsf.buself = .t.

		m.btext = strtran(m.btext, 0h0d0a, 0h0a)

		strtofile(m.btext, addbs(inst_gsf.isrvfolder) + '_install_mods.sh')

	else

		strtofile(m.btext, addbs(inst_gsf.isrvfolder) + '_install_mods.cmd')

	endif


endscan

*!* COPY CONFIG FOLDER

m.foldersource = addbs(inst_gsf.ifolder) + '..\config'

m.foldertarget = addbs(inst_gsf.isrvfolder) + 'config'

_deletefolder(m.foldertarget, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400)

_apicreatedirectory(m.foldertarget, 0)

m.result = _copyfolder(m.foldersource, m.foldertarget, _vfp.hwnd, 0x0010, 'COPY CONFIG FOLDER')

*!* CREATE INSTALL BATCH FILES

select 'batch_gsf'

scan

	m.btext  = batch_gsf.btext

	m.btext = strtran(m.btext, '[MC_VERSION]', getwordnum(inst_gsf.iminecraft, getwordcount(inst_gsf.iminecraft)))

	m.btext = strtran(m.btext, '[LOADER_VERSION]', getwordnum(inst_gsf.iloader, getwordcount(inst_gsf.iloader)))

	m.btext = strtran(m.btext, '[JAVA_PARAMS]', batch_gsf.javaparams)

	m.btext = strtran(m.btext, '[INSTALLER_VERSION]', _inigetvalue('INSTALLER_VERSION', '0.5.0.33'))

	m.btext = strtran(m.btext, '[PACK_NAME]', inst_gsf.iname)

	if batch_gsf.buself = .t.

		m.btext = strtran(m.btext, 0h0d0a, 0h0a)

		strtofile(m.btext, addbs(inst_gsf.isrvfolder) + '_install.sh')

	else

		strtofile(m.btext, addbs(inst_gsf.isrvfolder) + '_install.cmd')

	endif

endscan

*!* COPY SERVER ICON

_apicopyfile(addbs(inst_gsf.ifolder) + '..\..\server-icon.png', addbs(inst_gsf.isrvfolder) + 'server-icon.png', 0)

_logwrite('GENERATE SERVER INSTANCE END', inst_gsf.isrvfolder)

messagebox('SERVER FILES GENERATED IN ' + inst_gsf.isrvfolder, 64, 'MODROBOT')

use in 'inst_gsf'

use in 'mods_gsf'

use in 'batch_gsf'

use in 'modids_gsf'

use in 'files_gsf'

_restorearea(m.nselect)












