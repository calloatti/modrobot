* ! * mr_genserverzip

lparameters piguid, pserverfolder

Local fail, nselect, serverfolder, zfilepath, zipbasefolder, zipfilename

m.nselect = select()

if not used('inst_giz')

	use 'mr_instances' again alias 'inst_giz' in 0

endif

m.fail = .f.

if m.fail = .f. and seek(m.piguid, 'inst_giz', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	m.fail = .t.

endif

if m.fail = .f. and empty(inst_giz.izipfolder)

	messagebox('ERROR: INSTANCE OUTPUT ZIP FOLDER NOT SPECIFIED', 64, 'MODROBOT')

	m.fail = .t.

endif

* ! * SERVER

if empty(m.pserverfolder)

	m.serverfolder = rtrim(inst_giz.isrvfolder, 1, '\')

else

	m.serverfolder = rtrim(m.pserverfolder, 1, '\')

endif

if m.fail = .f. and empty(m.serverfolder)

	messagebox('ERROR: SERVER FOLDER NOT SPECIFIED', 64, 'MODROBOT')

	m.fail = .t.

endif

if m.fail = .f.

	m.zipbasefolder = justpath(m.serverfolder)

	*m.zipfilename = lower(inst_giz.izipfolder + justfname(_zipgetzfilepath(m.serverfolder, m.zipbasefolder)) + '.zip')

	m.zipfilename = _cleanfilename(inst_giz.izipfolder + lower(chrtran(inst_giz.iname, ' ', '_')) + '_server.zip')

	_logwrite('GENERATE SERVER ZIP START')

	_logwrite('SOURCE FOLDER:', m.serverfolder)

	_logwrite('ZIP FILE:', m.zipfilename)

	_findfilesinfoldertree(m.serverfolder, '*.*')

	_zipopen()

	select 'foundfiles'

	scan

		*m.zfilepath = _zipgetzfilepath(foundfiles.filename, m.zipbasefolder)

		m.zfilepath = _zipgetzfilepath(foundfiles.filename, m.serverfolder)

		_logwrite(m.zfilepath)

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endscan

	_zipclose(m.zipfilename)
	
	mr_rezipthezip(m.zipfilename)

	_logwrite('GENERATE SERVER ZIP END')

endif

use in 'inst_giz'

_restorearea(m.nselect)

 