*!* mr_genextraszip

lparameters piguid

local instancefolder, modfilename, nselect, zfilepath, zipbasefolder, zipfilename

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

m.instancefolder = mr_getinstancefolderfrommodsfolder(inst_giz.ifolder)

m.zipbasefolder = inst_giz.ifolder

if empty(inst_giz.iname)

	m.zipfilename = inst_giz.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + '_extras.zip'

else

	m.zipfilename = _cleanfilename(inst_giz.izipfolder + lower(chrtran(inst_giz.iname, ' ', '_')) + '_extras.zip')

endif

_logwrite('GENERATE EXTRAS ZIP START')

_logwrite('SOURCE FOLDER:', inst_giz.ifolder)

_logwrite('ZIP FILE:', m.zipfilename)

_zipopen()

*!* now scan instance mods and add jars that have no cf id (DISABLED, DONE IN CREATE EXTRAS ZIP)

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

mr_rezipthezip(m.zipfilename)

_logwrite('GENERATE EXTRAS ZIP END')

use in 'inst_giz'

use in 'mods_giz'

_restorearea(m.nselect)


