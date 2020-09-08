*!* mr_getmodproperties

lparameters pfile, pbytes

local omp as 'empty'
local jsonfabric, jsonforge, jsonlitemod, jsonrift, laprops[1], lnc, lnx, ojson, tomlforge

m.omp = createobject('empty')

addproperty(m.omp, 'mod_id', '')
addproperty(m.omp, 'mod_name', '')
addproperty(m.omp, 'mod_authors', '')
addproperty(m.omp, 'mod_environment', '')
addproperty(m.omp, 'mod_loader', '')
addproperty(m.omp, 'mod_version', '')
addproperty(m.omp, 'mod_environment', '')
addproperty(m.omp, 'mod_requires', '')
addproperty(m.omp, 'mod_depends', '')
addproperty(m.omp, 'mod_jars[1]', '')
addproperty(m.omp, 'jsonfabric', '')
addproperty(m.omp, 'jsonmixins', '')
addproperty(m.omp, 'jsonrefmap', '')
addproperty(m.omp, 'mod_icon', '')

addproperty(m.omp, 'depends', createobject('empty'))

addproperty(m.omp.depends, 'fabric', '')
addproperty(m.omp.depends, 'fabricloader', '')
addproperty(m.omp.depends, 'minecraft', '')

m.jsonfabric  = ''
m.jsonforge	  = ''
m.tomlforge	  = ''
m.jsonrift	  = ''
m.jsonlitemod = ''

*!* FABRIC

do case

case not empty(m.pfile) and file(m.pfile)

	m.jsonfabric = mr_getfilefromzipfile(m.pfile, 'fabric.mod.json')

	m.jsonforge = mr_getfilefromzipfile(m.pfile, 'mcmod.info')

	m.tomlforge = mr_getfilefromzipfile(m.pfile, 'META-INF\mods.toml')

	*!*	      m.jsonrift = mr_getfilefromzipfile(m.pfile, 'riftmod.json')

	*!*	      m.jsonlitemod = mr_getfilefromzipfile(m.pfile, 'litemod.json')

	if empty(m.tomlforge)

		m.tomlforge = mr_getfilefromzipfile(m.pfile, 'META_INF\mods.toml')

	endif

case not empty(m.pbytes)

	m.jsonfabric = mr_getfilefromzipdata(m.pbytes, 'fabric.mod.json')

	m.jsonforge = mr_getfilefromzipdata(m.pbytes, 'mcmod.info')

	m.tomlforge = mr_getfilefromzipdata(m.pbytes, 'META-INF\mods.toml')

	*!*	      m.jsonrift = mr_getfilefromzipdata(m.pbytes, 'riftmod.json')

	*!*	      m.jsonlitemod = mr_getfilefromzipdata(m.pbytes, 'litemod.json')

	if empty(m.tomlforge)

		m.tomlforge = mr_getfilefromzipdata(m.pfile, 'META_INF\mods.toml')

	endif

otherwise

	error 'FILE NOT FOUND AND NO FILE DATA PARAMETER'

endcase

*!* FABRIC

if not empty(m.jsonfabric)

	m.omp.jsonfabric = m.jsonfabric

	m.omp.mod_loader = m.omp.mod_loader + 'FABRIC|'

	m.ojson = nfjsonread(m.jsonfabric)

	if type('m.ojson.name') = 'C'

		m.omp.mod_name = m.ojson.name

	endif

	if type('m.ojson.authors[1]') = 'C'

		m.omp.mod_authors = m.ojson.authors[1]

	endif

	m.omp.mod_id = m.ojson.id

	if type('m.ojson.icon') = 'C' and not empty(m.ojson.icon)

		do case

		case not empty(m.pfile) and file(m.pfile)

			m.omp.mod_icon = mr_getfilefromzipfile(m.pfile, m.ojson.icon)

		case not empty(m.pbytes)

			m.omp.mod_icon = mr_getfilefromzipdata(m.pbytes, m.ojson.icon)

		endcase

	endif

	if type('m.ojson.version') = 'C'

		m.omp.mod_version = m.ojson.version

	endif

	if type('m.ojson.environment') = 'C'

		m.omp.mod_environment = m.ojson.environment

	endif

	if type('m.ojson.requires') = 'O'

		m.lnc = amembers(laprops, m.ojson.requires)

		for m.lnx = 1 to m.lnc

			if lower(m.laprops[m.lnx]) == 'fabricloader'

				loop

			endif

			m.omp.mod_requires = m.omp.mod_requires + lower(m.laprops[m.lnx]) + '|'

		endfor

		m.omp.mod_requires = rtrim(m.omp.mod_requires, 1, '|')

	endif

	if type('m.ojson.jars[1].file') = 'C'

		= acopy(m.ojson.jars, m.omp.mod_jars)

	endif

endif

if type('m.ojson.depends') = 'O'

	m.lnc = amembers(laprops, m.ojson.depends)

	for m.lnx = 1 to m.lnc

		m.omp.mod_depends = m.omp.mod_depends + m.laprops[m.lnx] + '|'

	endfor

	m.omp.mod_depends = rtrim(m.omp.mod_depends, 1, '|')

endif

if type('m.ojson.depends.fabricloader') = 'C'

	m.omp.depends.fabricloader = m.ojson.depends.fabricloader

endif

if type('m.ojson.depends.fabric') = 'C'

	m.omp.depends.fabric = m.ojson.depends.fabric

endif

if type('m.ojson.depends.minecraft') = 'C'

	m.omp.depends.minecraft = m.ojson.depends.minecraft

endif


if type('m.ojson.requires.fabricloader') = 'C'

	m.omp.depends.fabricloader = m.ojson.requires.fabricloader

endif

if type('m.ojson.requires.fabric') = 'C'

	m.omp.depends.fabric = m.ojson.requires.fabric

endif

*!* FORGE

if not empty(m.jsonforge)

	m.omp.mod_loader = m.omp.mod_loader + 'FORGE|'

	m.ojson = nfjsonread(m.jsonforge)

	if type('m.ojson.array[1].modid') = 'C'

		m.omp.mod_id = m.ojson.array[1].modid

	endif

	if type('m.ojson.array[1].name') = 'C'

		m.omp.mod_name = m.ojson.array[1].name

	endif

	if type('m.ojson.array[1].authorList[1]') = 'C'

		m.omp.mod_authors = m.ojson.array[1].authorList[1]

	endif

	if type('m.ojson.array[1].version') = 'C'

		m.omp.mod_version = m.ojson.array[1].version

	endif


	if type('m.ojson.modList[1].modid') = 'C'

		m.omp.mod_id = m.ojson.modList[1].modid

	endif

	if type('m.ojson.modList[1].name') = 'C'

		m.omp.mod_name = m.ojson.modList[1].name

	endif

	if type('m.ojson.modList[1].authorList[1]') = 'C'

		m.omp.mod_authors = m.ojson.modList[1].authorList[1]

	endif

	if type('m.ojson.modList[1].version') = 'C'

		m.omp.mod_version = m.ojson.modList[1].version

	endif


endif

*!* FORGE TOML

if not empty(m.tomlforge)

	m.omp.mod_loader = m.omp.mod_loader + 'FORGE|'

	m.omp.mod_id = strextract(m.tomlforge, 'modId="', '"')

	m.omp.mod_name = strextract(m.tomlforge, 'displayName="', '"')

	m.omp.mod_authors = strextract(m.tomlforge, 'authors="', '"')

	m.omp.mod_version = strextract(m.tomlforge, 'version="', '"')

endif


*!* RIFT

if not empty(m.jsonrift)

	m.omp.mod_loader = m.omp.mod_loader + 'RIFT|'

	m.ojson = nfjsonread(m.jsonrift)

	m.omp.mod_id = m.ojson.id

	if type('m.ojson.name') = 'C'

		m.omp.mod_name = m.ojson.name

	endif

	if type('m.ojson.authors[1]') = 'C'

		m.omp.mod_authors = m.ojson.authors[1]

	endif

endif

*!* LITEMOD

if not empty(m.jsonlitemod)

	m.omp.mod_loader = m.omp.mod_loader + 'LITELOADER|'

	m.ojson = nfjsonread(m.jsonlitemod)

	m.omp.mod_id = m.ojson.name

	if type('m.ojson.displayName') = 'C'

		m.omp.mod_name = m.ojson.displayName

	endif

	if type('m.ojson.author') = 'C'

		m.omp.mod_authors = m.ojson.author

	endif

	if type('m.ojson.version') = 'C'

		m.omp.mod_version = m.ojson.version

	endif

endif

if empty(m.omp.mod_id)

	m.omp.mod_id = upper(juststem(m.pfile))

endif

m.omp.mod_loader = rtrim(m.omp.mod_loader, 1, '|')

return m.omp










