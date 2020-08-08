*!* mr_syncservermodsfolder

lparameters piguid

local filesource, filetarget, foldersource, foldertarget, nselect, result

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

if not used('mods_gsf')

	use 'mr_mods' again alias 'mods_gsf' in 0 order tag 'filename1'

endif

if not used('modids_gsf')

	use 'mr_modids' again alias 'modids_gsf' in 0

endif

_logwrite('SYNC SERVER MODS FOLDER START', inst_gsf.isrvfolder)

*!* COPY MODS

m.foldersource = addbs(inst_gsf.ifolder)

m.foldertarget = rtrim(inst_gsf.isrvfolder, 1, '\')

_apicreatedirectory(m.foldertarget, 0)

m.foldertarget = addbs(inst_gsf.isrvfolder) + 'mods'

_deletefolder(m.foldertarget, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400)

_apicreatedirectory(m.foldertarget, 0)

m.foldertarget = addbs(m.foldertarget)

select 'mods_gsf'

scan for mods_gsf.iguid == m.piguid

	if lower(justext(mods_gsf.filename1)) = 'disabled'

		loop

	endif

	if lower(mods_gsf.env) == 'client'

		loop

	endif

	if seek(mods_gsf.modid, 'modids_gsf', 'modid') = .t. and modids_gsf.isclient = .t.

		loop

	endif

	m.filesource = m.foldersource + mods_gsf.filename1

	m.filetarget = m.foldertarget + mods_gsf.filename1

	_logwrite('COPY MOD', m.filesource, m.filetarget)

	m.result = _apicopyfile(m.filesource, m.filetarget, 0)

	if m.result = 0

		_logwrite('COPY MOD ERROR', m.filesource)

	endif

endscan

_logwrite('SYNC SERVER MODS FOLDER END', inst_gsf.isrvfolder)


m.foldertarget = addbs(inst_gsf.isrvfolder) + 'config'

m.foldersource = justpath(inst_gsf.ifolder) + '\config'

_logwrite('SYNC SERVER CONFIG FOLDER START', m.foldersource, '->', m.foldertarget)

_deletefolder(m.foldertarget, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400)

_logwrite('CREATEDIRECTORY ' + m.foldertarget + ' RESULT:',_apicreatedirectory(m.foldertarget, 0))

_logwrite('COPYFOLDER RESULT:', _copyfolder(m.foldersource, m.foldertarget, application.hWnd, 0, 'Copy config'))

_logwrite('SYNC SERVER CONFIG FOLDER END')

use in 'inst_gsf'

use in 'mods_gsf'

use in 'modids_gsf'


_restorearea(m.nselect)













