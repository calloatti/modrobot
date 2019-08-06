*!* mr_getmodproperties

Lparameters pfile, pbytes

Local omp As 'empty'
Local jsonfabric, jsonforge, jsonlitemod, jsonrift, laprops[1], lnc, lnx, ojson, tomlforge

m.omp = Createobject('empty')

AddProperty(m.omp, 'mod_id', '')
AddProperty(m.omp, 'mod_name', '')
AddProperty(m.omp, 'mod_authors', '')
AddProperty(m.omp, 'mod_environment', '')
AddProperty(m.omp, 'mod_loader', '')
AddProperty(m.omp, 'mod_version', '')
AddProperty(m.omp, 'mod_environment', '')
AddProperty(m.omp, 'mod_requires', '')
AddProperty(m.omp, 'mod_depends', '')
AddProperty(m.omp, 'mod_jars[1]', '')
AddProperty(m.omp, 'jsonfabric', '')

*!* FABRIC

Do Case

   Case Not Empty(m.pfile) And File(m.pfile)

      m.jsonfabric = mr_getfilefromzipfile(m.pfile, 'fabric.mod.json')

      m.jsonforge = mr_getfilefromzipfile(m.pfile, 'mcmod.info')

      m.tomlforge = mr_getfilefromzipfile(m.pfile, 'META_INF\mods.toml')

      m.jsonrift = mr_getfilefromzipfile(m.pfile, 'riftmod.json')

      m.jsonlitemod = mr_getfilefromzipfile(m.pfile, 'litemod.json')

   Case Not Empty(m.pbytes)

      m.jsonfabric = mr_getfilefromzipdata(m.pbytes, 'fabric.mod.json')

      m.jsonforge = mr_getfilefromzipdata(m.pbytes, 'mcmod.info')

      m.tomlforge = mr_getfilefromzipdata(m.pbytes, 'META_INF\mods.toml')

      m.jsonrift = mr_getfilefromzipdata(m.pbytes, 'riftmod.json')

      m.jsonlitemod = mr_getfilefromzipdata(m.pbytes, 'litemod.json')

   Otherwise

      Error 'FILE NOT FOUND AND NO FILE DATA PARAMETER'

Endcase

*!* FABRIC

If Not Empty(m.jsonfabric)

   m.omp.jsonfabric = m.jsonfabric

   m.omp.mod_loader = m.omp.mod_loader + 'FABRIC|'

   m.ojson = nfjsonread(m.jsonfabric)

   If Type('m.ojson.name') = 'C'

      m.omp.mod_name = m.ojson.Name

   Endif

   If Type('m.ojson.authors[1]') = 'C'

      m.omp.mod_authors = m.ojson.authors[1]

   Endif

   m.omp.mod_id = m.ojson.Id

   If Type('m.ojson.version') = 'C'

      m.omp.mod_version = m.ojson.Version

   Endif

   If Type('m.ojson.environment') = 'C'

      m.omp.mod_environment = m.ojson.Environment

   Endif

   If Type('m.ojson.requires') = 'O'

      m.lnc = Amembers(laprops, m.ojson.requires)

      For m.lnx = 1 To m.lnc

         If Lower(m.laprops[m.lnx]) == 'fabricloader'

            Loop

         Endif

         m.omp.mod_requires = m.omp.mod_requires + Lower(m.laprops[m.lnx]) + '|'

      Endfor

      m.omp.mod_requires = Rtrim(m.omp.mod_requires, 1, '|')

   Endif

   If Type('m.ojson.jars[1].file') = 'C'

      = Acopy(m.ojson.jars, m.omp.mod_jars)

   Endif

Endif

If Type('m.ojson.depends') = 'O'

   m.lnc = Amembers(laprops, m.ojson.depends)

   For m.lnx = 1 To m.lnc

      m.omp.mod_depends = m.omp.mod_depends + m.laprops[m.lnx] + '|'

   Endfor

   m.omp.mod_depends = Rtrim(m.omp.mod_depends, 1, '|')

Endif

*!* FORGE

If Not Empty(m.jsonforge)

   m.omp.mod_loader = m.omp.mod_loader + 'FORGE|'

   m.ojson = nfjsonread(m.jsonforge)

   If Type('m.ojson.array[1].modid') = 'C'

      m.omp.mod_id = m.ojson.Array[1].modid

   Endif

   If Type('m.ojson.array[1].name') = 'C'

      m.omp.mod_name = m.ojson.Array[1].Name

   Endif

   If Type('m.ojson.array[1].authorList[1]') = 'C'

      m.omp.mod_authors = m.ojson.Array[1].authorList[1]

   Endif

   If Type('m.ojson.array[1].version') = 'C'

      m.omp.mod_version = m.ojson.Array[1].Version

   Endif

Endif

*!* FORGE TOML

If Not Empty(m.tomlforge)

   m.omp.mod_loader = m.omp.mod_loader + 'FORGET|'

   m.omp.mod_id = Strextract(m.tomlforge, 'modId="', '"')

   m.omp.mod_name = Strextract(m.tomlforge, 'displayName="', '"')

   m.omp.mod_authors = Strextract(m.tomlforge, 'authors="', '"')

   m.omp.mod_version = Strextract(m.tomlforge, 'version="', '"')

Endif


*!* RIFT

If Not Empty(m.jsonrift)

   m.omp.mod_loader = m.omp.mod_loader + 'RIFT|'

   m.ojson = nfjsonread(m.jsonrift)

   m.omp.mod_id = m.ojson.Id

   If Type('m.ojson.name') = 'C'

      m.omp.mod_name = m.ojson.Name

   Endif

   If Type('m.ojson.authors[1]') = 'C'

      m.omp.mod_authors = m.ojson.authors[1]

   Endif

Endif

*!* LITEMOD

If Not Empty(m.jsonlitemod)

   m.omp.mod_loader = m.omp.mod_loader + 'LITELOADER|'

   m.ojson = nfjsonread(m.jsonlitemod)

   m.omp.mod_id = m.ojson.Name

   If Type('m.ojson.displayName') = 'C'

      m.omp.mod_name = m.ojson.displayName

   Endif

   If Type('m.ojson.author') = 'C'

      m.omp.mod_authors = m.ojson.author

   Endif

   If Type('m.ojson.version') = 'C'

      m.omp.mod_version = m.ojson.Version

   Endif

Endif

m.omp.mod_loader = Rtrim(m.omp.mod_loader, 1, '|')

Return m.omp



