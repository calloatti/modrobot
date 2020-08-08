*!* mr_modupdate

lparameters prguid

Local bfolder, file1, file1backup, file2, hfile, nselect, remotefile, result

m.nselect = select()

if not used('mup_mods')

	use 'mr_mods' again alias 'mup_mods' in 0

endif

if not used('mup_instances')

	use 'mr_instances' again alias 'mup_instances' in 0

endif

if not used('mup_log')

	use 'mr_log' again alias 'mup_log' in 0

endif

if seek(m.prguid, 'mup_mods', 'rguid') = .f.

	_logwrite('MODUPDATE ERROR: RGUID NOT FOUND IN MR_MODS')
	
	mr_modupdate_cleanup(m.nselect)

	return

endif

if seek(mup_mods.iguid, 'mup_instances', 'iguid') = .f.

	_logwrite('MODUPDATE ERROR: IGUID NOT FOUND IN MR_INSTANCES')

	mr_modupdate_cleanup(m.nselect)

	return

endif

if mup_mods.fid1 = 0 or mup_mods.fid2 = 0 or mup_mods.fid1 = mup_mods.fid2

	mr_modupdate_cleanup(m.nselect)

	return

endif

m.file1	= addbs(mup_instances.ifolder) + mup_mods.filename1

*!* DO NOT UPDATE DISABLED MODS

if justext(m.file1) = 'disabled'

	_logwrite('MODUPDATE ERROR: MOD IS DISABLED')

	mr_modupdate_cleanup(m.nselect)

	return

endif

*!* CHECK IF OLD FILE CAN BE OPENED EXCLUSIVE, IF NOT MC MAY BE RUNNING

m.hfile = _apicreatefile(m.file1, 0x40000000, 0, 0, 3, 0, 0)

if m.hfile = -1

	_logwrite('MODUPDATE ERROR: UNABLE TO LOCK FILE, IS MINECRAFT RUNNING?')

	mr_modupdate_cleanup(m.nselect)

	return

endif

_apiclosehandle(m.hfile)

*!* CHECK IF FILE TO DOWNLOAD ALREADY EXISTS AND HAS CORRECT HASH

m.file2	= addbs(mup_instances.ifolder) + mup_mods.filename2

if _file(m.file2)

	if mr_fingerprint(m.file2) = mup_mods.hash2

		_logwrite('MODUPDATE ERROR: FILE ALREADY EXISTS', m.file2)

		mr_modupdate_cleanup(m.nselect)

		return

	else

		*!* DELETE FILE WITH WRONG HASH

		_apideletefile(m.file2)

	endif

endif

*!* MOVE OLD FILE TO BACKUP FIRST, JUST IN CASE NEW FILE HAS THE SAME NAME

m.bfolder = addbs(mup_instances.ifolder) + '..\mods.backup'

_apiCreateDirectory(m.bfolder, 0)

m.file1backup = addbs(m.bfolder) + mup_mods.filename1

if _file(m.file1)

	*!* IF THERE IS ALREADY A BACKUP OF FILE1, JUST DELETE IT

	if _file(m.file1backup) and mr_fingerprint(m.file1backup) = mup_mods.hash1

		_apideletefile(m.file1)

	endif

	*!* IF THERE IS A BACKUP WITH THE SAME NAME BUT # HASH, ADD RANDOM EXTENSION

	if _file(m.file1backup)

		m.file1backup = addbs(m.bfolder) + mup_mods.filename1 + '.' + sys(2015)

	endif

	_apimovefile(m.file1, m.file1backup)

endif

*!* DO ACTUAL DOWNLOAD

m.remotefile = mr_geturlfile1(mup_mods.fid2, mup_mods.filename2)

_logwrite('MODUPDATE START', m.remotefile)

m.result = mr_downloadfile(m.remotefile, m.file2)

if m.result = 0 or mup_mods.hash2 # mr_fingerprint(m.file2)

	_apideletefile(m.pfile2)

	_logwrite('MODUPDATE ERROR: DOWNLOAD FAILED')

	*!* RESTORE ORIGINAL FILE

	if _file(m.file1backup)

		_apimovefile(m.file1backup, m.file1)

	endif

	mr_modupdate_cleanup(m.nselect)

	return

endif

*!* UPDATE LOG TABLE

append blank in 'mup_log'

replace mup_log.fid1 with mup_mods.fid1 in 'mup_log'
replace mup_log.fid2 with mup_mods.fid2 in 'mup_log'
replace mup_log.filename1 with mup_mods.filename1 in 'mup_log'
replace mup_log.filename2 with mup_mods.filename2 in 'mup_log'
replace mup_log.hash1 with mup_mods.hash1 in 'mr_mods1'
replace mup_log.hash2 with mup_mods.hash2 in 'mr_mods1'

replace mup_log.ifolder with mup_instances.ifolder in 'mup_log'
replace mup_log.iguid with mup_mods.iguid in 'mup_log'

replace mup_log.ldatetime with datetime() in 'mup_log'

replace mup_log.ldesc with 'UPDATED' in 'mup_log'

*!* UPDATE MODS TABLE

replace mup_mods.fid1 with mup_mods.fid2 in 'mup_mods'
replace mup_mods.filedate1 with mup_mods.filedate2 in 'mup_mods'
replace mup_mods.filelen1 with mup_mods.filelen2 in 'mup_mods'
replace mup_mods.filename1 with mup_mods.filename2 in 'mup_mods'
replace mup_mods.gver1 with mup_mods.gver2 in 'mup_mods'
replace mup_mods.loader1 with mup_mods.loader2 in 'mup_mods'
replace mup_mods.rtypename1 with mup_mods.rtypename2 in 'mup_mods'
replace mup_mods.hash1 with mup_mods.hash2 in 'mup_mods'

replace mup_mods.fguid with strconv(_ubintoc(mup_mods.hash1), 15) in 'mup_mods'

replace mup_mods.rguid with mup_mods.iguid + mup_mods.fguid in 'mup_mods'

_logwrite('MODUPDATE END')

procedure mr_modupdate_cleanup

lparameters pnselect

use in 'mup_mods'
use in 'mup_instances'
use in 'mup_log'

_restorearea(m.pnselect)

endproc
 