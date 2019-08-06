*!* mr_genserverfolder

Lparameters piguid

Local batchname, batchtext, filesource, filetarget, nselect, result, foldersource, foldertarget

m.nselect = Select()

If Not Used('inst_gsf')

   Use 'mr_instances' Again Alias 'inst_gsf' In 0

Endif

If Seek(m.piguid, 'inst_gsf', 'iguid') = .F.

   Messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

   Use In 'inst_gsf'

   _restorearea(m.nselect)

   Return

Endif

If  Empty(inst_gsf.iserverfol)

   Messagebox('ERROR: INSTANCE SERVER FOLDER IS EMPTY', 64, 'MODROBOT')

   Use In 'inst_gsf'

   _restorearea(m.nselect)

   Return

Endif

If Not Used('batch_gsf')

   Use 'mr_batch' Again Alias 'batch_gsf' In 0

Endif

If Not Used('mods_gsf')

   Use 'mr_mods' Again Alias 'mods_gsf' In 0

Endif

_logwrite('GENERATE SERVER INSTANCE START', inst_gsf.iserverfol)

*!* COPY MODS

m.foldersource = Addbs(inst_gsf.ifolder)

m.foldertarget = Addbs(inst_gsf.iserverfol) + 'mods'

_apicreatedirectory(m.foldertarget, 0)

m.foldertarget = Addbs(m.foldertarget)

Select 'mods_gsf'

Scan For mods_gsf.iguid == m.piguid And Not Lower(mods_gsf.env) == 'client'

   m.filesource = m.foldersource + mods_gsf.filename1

   m.filetarget = m.foldertarget + mods_gsf.filename1

   _logwrite('COPY FILE', m.filesource, 'TO', m.filetarget)

   m.result = _apicopyfile(m.filesource, m.filetarget, 0)

   If m.result = 0

      _logwrite('COPY FILE ERROR', m.filesource)

   Endif

Endscan

*!* COPY CONFIG FOLDER

m.foldersource = Addbs(inst_gsf.ifolder) + '..\config'

m.foldertarget = Addbs(inst_gsf.iserverfol) + 'config'

_apicreatedirectory(m.foldertarget, 0)

_logwrite('COPY CONFIG START', m.foldersource, m.foldertarget)

m.result = _copyfolder(m.foldersource, m.foldertarget, _vfp.HWnd, 0x0010, 'COPY CONFIG FOLDER')

_logwrite('COPY CONFIG END', m.result)

*!* CREATE BATCH FILES

Select 'batch_gsf'

Scan

   m.batchname = batch_gsf.bname

   m.batchtext = batch_gsf.btext

   m.batchtext = Strtran(m.batchtext, '[MCVERSION]', Getwordnum(inst_gsf.iminecraft, Getwordcount(inst_gsf.iminecraft)))

   m.batchtext = Strtran(m.batchtext, '[LOADERVERSION]', Getwordnum(inst_gsf.iloader, Getwordcount(inst_gsf.iloader)))

   m.batchtext = Strtran(m.batchtext, '[PARAMS1]', batch_gsf.bparams1)

   m.batchtext = Strtran(m.batchtext, '[PARAMS2]', batch_gsf.bparams2)

   m.batchtext = Strtran(m.batchtext, '[SERVERVERSION]', Getwordnum(inst_gsf.iserverfol, Getwordcount(inst_gsf.iserverfol,'\'),'\'))

   Strtofile(m.batchtext, Addbs(inst_gsf.iserverfol) + batch_gsf.bname)

Endscan


*!* COPY SERVER ICON

_apicopyfile(Addbs(inst_gsf.ifolder) + '..\..\server-icon.png', Addbs(inst_gsf.iserverfol) + 'server-icon.png', 0)

_logwrite('GENERATE SERVER INSTANCE END', inst_gsf.iserverfol)

Messagebox('SERVER FILES GENERATED IN ' + inst_gsf.iserverfol, 64, 'MODROBOT')

Use In 'inst_gsf'

Use In 'mods_gsf'

Use In 'batch_gsf'

_restorearea(m.nselect)






