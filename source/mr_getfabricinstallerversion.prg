*!* mr_getfabricinstallerversion

lparameters pforce

local fabric_installer_version, xml

m.fabric_installer_version = _inigetvalue('FABRIC_INSTALLER_VERSION', '0.0.0.0')

if m.pforce = .t. or m.fabric_installer_version == '0.0.0.0'

	_logwrite('GET FABRIC INSTALLER VERSION DATA START')

	m.xml = mr_downloadstring('https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml')

	if not empty(m.xml)

		m.fabric_installer_version = strextract(m.xml, '<version>', '</version>', occurs('<version>', m.xml))

		_inisetvalue('FABRIC_INSTALLER_VERSION', m.fabric_installer_version)

	endif

	_logwrite('GET FABRIC INSTALLER VERSION DATA END')

endif