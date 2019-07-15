*!* mr_modupdate

Lparameters prguid

Local bfolder, file1, file2, file1a, hfile, nselect, remotefile, result

m.nselect = Select()

If Not Used('mods_um')

   Use 'mr_mods' Again Alias 'mods_um' In 0

Endif

If Not Used('instances_um')

   Use 'mr_instances' Again Alias 'instances_um' In 0

Endif

If Not Used('log_um')

   Use 'mr_log' Again Alias 'log_um' In 0

Endif

If Seek(m.prguid, 'mods_um', 'rguid') = .F.

   _restorearea(m.nselect)

   Return

Endif

If Seek(mods_um.iguid, 'instances_um', 'iguid') = .F.

   _restorearea(m.nselect)

   Return

Endif

If mods_um.fid1 = 0 Or mods_um.fid2 = 0 Or mods_um.fid1 = mods_um.fid2

   _restorearea(m.nselect)

   Return

Endif


m.file1	= Addbs(instances_um.ifolder) + mods_um.filename1


*!* DO NOT UPDATE DISABLED MODS

If Justext(m.file1) = 'disabled'

   _restorearea(m.nselect)

   Return

Endif


*!* CHECK IF OLD FILE CAN BE OPENED EXCLUSIVE, IF NOT MC MAY BE RUNNING

m.hfile = _apicreatefile(m.file1, 0x40000000, 0, 0, 3, 0, 0)

If m.hfile = -1

   _logwrite('UPDATE ERROR: FILE LOCKED, IS MINECRAFT RUNNING?')

   _restorearea(m.nselect)

   Return

Endif

_apiclosehandle(m.hfile)

*!* CHECK IF FILE TO DOWNLOAD ALREADY EXISTS AND HAS CORRECT HASH

m.file2	= Addbs(instances_um.ifolder) + mods_um.filename2

If _file(m.file2) And mr_fingerprint(m.file2) = mods_um.hash2

   _logwrite('UPDATE ERROR: FILE EXISTS', m.file2)

   _restorearea(m.nselect)

   Return

Endif

If _file(m.file2)

   _apideletefile(m.file2)

Endif

m.remotefile = mr_geturlfile1(mods_um.fid2, mods_um.filename2)

_logwrite('UPDATE START', m.remotefile)

m.result = mr_downloadfile(m.remotefile, m.file2)

If m.result = 0

   _logwrite('UPDATE ERROR: DOWNLOAD FAILED')

   _restorearea(m.nselect)

   Return

Endif

If mods_um.hash2 # mr_fingerprint(m.file2)

   _apideletefile(m.pfile2)

   _logwrite('UPDATE ERROR: FILE HAS WRONG HASH')

   _restorearea(m.nselect)

   Return

Endif

m.bfolder = Addbs(instances_um.ifolder) + '..\mods.backup'

_apiCreateDirectory(m.bfolder, 0)

m.file1a = Addbs(m.bfolder) + mods_um.filename1

If _file(m.file1a) And mr_fingerprint(m.file1a) = mods_um.hash1

   _apideletefile(m.file1)

Endif

If _file(m.file1a)

   m.file1a = Addbs(m.bfolder) + mods_um.filename1 + '.' + Sys(2015)

Endif

If _file(m.file1)

   _apimovefile(m.file1, m.file1a)

Endif

*!* UPDATE LOG TABLE

Append Blank In 'log_um'

Replace log_um.fid1 With mods_um.fid1 In 'log_um'
Replace log_um.fid2 With mods_um.fid2 In 'log_um'
Replace log_um.filename1 With mods_um.filename1 In 'log_um'
Replace log_um.filename2 With mods_um.filename2 In 'log_um'
Replace log_um.hash1 With mods_um.hash1 In 'mr_mods1'
Replace log_um.hash2 With mods_um.hash2 In 'mr_mods1'

Replace log_um.ifolder With instances_um.ifolder In 'log_um'
Replace log_um.iguid With mods_um.iguid In 'log_um'

Replace log_um.ldatetime With Datetime() In 'log_um'

Replace log_um.ldesc With 'UPDATED' In 'log_um'

*!* UPDATE MODS TABLE

Replace mods_um.fid1 With mods_um.fid2 In 'mods_um'
Replace mods_um.filedate1 With mods_um.filedate2 In 'mods_um'
Replace mods_um.filelen1 With mods_um.filelen2 In 'mods_um'
Replace mods_um.filename1 With mods_um.filename2 In 'mods_um'
Replace mods_um.gver1 With mods_um.gver2 In 'mods_um'
Replace mods_um.loader1 With mods_um.loader2 In 'mods_um'
Replace mods_um.rtypename1 With mods_um.rtypename2 In 'mods_um'
Replace mods_um.hash1 With mods_um.hash2 In 'mods_um'

Replace mods_um.fguid With Strconv(_ubintoc(mods_um.hash1), 15) In 'mods_um'

Replace mods_um.rguid With mods_um.iguid + mods_um.fguid In 'mods_um'

_logwrite('UPDATE END')

Use In 'mods_um'
Use In 'instances_um'
Use In 'log_um'

_restorearea(m.nselect)




