* ! * mr_genserverzip

lparameters piguid

Local fail, zfilepath, instancefolder, nselect, zipbasefolder, zipfilename

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

if m.fail = .f. and empty(inst_giz.isrvfolder)

	messagebox('ERROR: INSTANCE INPUT SERVER FOLDER NOT SPECIFIED', 64, 'MODROBOT')

	m.fail = .t.

endif

if m.fail = .f.

	m.instancefolder = rtrim(inst_giz.isrvfolder, 1, '\')

	m.zipbasefolder = justpath(m.instancefolder)

	m.zipfilename = inst_giz.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + '.zip'

	_logwrite('GENERATE SERVER ZIP START')

	_logwrite('SOURCE FOLDER:', m.instancefolder)

	_logwrite('ZIP FILE:', m.zipfilename)

	_findfilesinfoldertree(m.instancefolder, '*.*')

	_zipopen()

	select 'foundfiles'

	scan

		m.zfilepath = _zipgetzfilepath(foundfiles.filename, m.zipbasefolder)

		_logwrite(m.zfilepath)

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endscan

	_zipclose(m.zipfilename)

	_logwrite('GENERATE SERVER ZIP END:', m.zipfilename)

endif

use in 'inst_giz'

_restorearea(m.nselect)
 