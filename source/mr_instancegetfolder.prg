*!* mr_instancegetfolder

Local iguid, lastfolder, selfolder

m.lastfolder = _inigetvalue('ADD_INSTANCE_LAST_FOLDER', set('Default'))

m.selfolder = getdir(m.lastfolder, 'Select MultimMC folder, MultimMC instances folder, instance folder or mods folder', '', 1 + 64 + 16 + 32)

m.iguid = ''

if not empty(m.selfolder) then

	_inisetvalue('ADD_INSTANCE_LAST_FOLDER', m.selfolder)

	do case

	case file(addbs(m.selfolder) + 'multimc.exe')

		*!* multimc root

		m.iguid = mr_instanceaddfolder(addbs(m.selfolder) + 'instances')

	case lower(justfname(rtrim(m.selfolder, 1, '\'))) == 'instances'

		*!* multimc instances root

		m.iguid = mr_instanceaddfolder(rtrim(m.selfolder, 1, '\'))

	case directory(addbs(m.selfolder) + '.minecraft\mods')

		*!* instance folder

		m.iguid = mr_instanceadd(addbs(m.selfolder) + '.minecraft\mods')

	case directory(addbs(m.selfolder) + 'minecraft\mods')

		*!* instance folder

		m.iguid = mr_instanceadd(addbs(m.selfolder) + 'minecraft\mods')

	case directory(addbs(m.selfolder) + 'mods')

		*!* minecraft folder

		m.iguid = mr_instanceadd(addbs(m.selfolder) + 'mods')

	otherwise

		*!* mods folder?

		m.iguid = mr_instanceadd(rtrim(m.selfolder, 1, '\'))

	endcase

endif

return m.iguid 