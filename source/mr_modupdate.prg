*!* mr_modupdate

lparameters prguid

local bgetfile, cbackfolder, cdownfolder, file1, file2, filebackup, filelocal, fileremote, hfile
local nselect, result

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

m.cdownfolder = _getapppath() + 'downloads'

_apicreatedirectory(m.cdownfolder, 0)

m.cbackfolder = addbs(mup_instances.ifolder) + '..\mods.backup'

_apicreatedirectory(m.cbackfolder, 0)

m.file1	= addbs(mup_instances.ifolder) + mup_mods.filename1

m.file2	= addbs(mup_instances.ifolder) + mup_mods.filename2

m.filelocal = addbs(m.cdownfolder) + mup_mods.filename2

m.filebackup = addbs(m.cbackfolder) + mup_mods.filename1 + '.' + transform(mup_mods.hash1)

*!* DO NOT UPDATE DISABLED MODS

if justext(m.file1) = 'disabled'

	_logwrite('MODUPDATE ERROR: MOD IS DISABLED')

	mr_modupdate_cleanup(m.nselect)

	return

endif

*!* CHECK FOR PROPER FINGERPRINT

if mr_fingerprint(m.file1) # mup_mods.hash1

	_logwrite('MODUPDATE ERROR: CURRENT FILE HASH ERROR, PLEASE SCAN FOLDER')

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

*!* CHECK IF FILE TO DOWNLOAD IS ALREADY DOWNLOADED

if file(m.filelocal) and mr_fingerprint(m.filelocal) = mup_mods.hash2

	m.bgetfile = .f.

else

	m.bgetfile = .t.

endif

*!* DO ACTUAL DOWNLOAD

if m.bgetfile = .t.

	m.fileremote = mr_geturlfile1(mup_mods.fid2, mup_mods.filename2)

	_logwrite('MODUPDATE START', m.fileremote)

	m.result = mr_downloadfile(m.fileremote, m.filelocal)

endif

*!* CHECK FILE WAS DOWNLOADED PROPERLY

if mup_mods.hash2 # mr_fingerprint(m.filelocal)

	_apideletefile(m.filelocal)

	_logwrite('MODUPDATE ERROR: DOWNLOAD FAILED')

	mr_modupdate_cleanup(m.nselect)

	return

endif

*!* AT THIS POINT WE SHOULD HAVE THE PROPER FILE IN THE DOWNLOADS FOLDER
*!* MOVE OLD FILE TO BACKUP FIRST, JUST IN CASE NEW FILE HAS THE SAME NAME


*!* IF THERE IS ALREADY A BACKUP OF FILE1, JUST DELETE ORIGINAL, LEAVE BACKUP
*!* AT THIS POINT THE BACKUP FILENAME INCLUDES THE HASH

if _file(m.filebackup)

	_apideletefile(m.file1)

else

	_apimovefile(m.file1, m.filebackup)

endif

*!* COPY DOWNLOADED FILE TO MODS FOLDER

_apicopyfile(m.filelocal, m.file2, 0)

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
replace mup_log.modid with mup_mods.modid in 'mup_log'
replace mup_log.filebackup with justfname(m.filebackup) in 'mup_log'

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















