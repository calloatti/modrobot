*!* mr_getmodproperties

Lparameters pfile

Local omp As 'empty'
Local json, lnx, ojson

m.omp = Createobject('empty')

AddProperty(m.omp, 'modid', '')
AddProperty(m.omp, 'aname', '')
AddProperty(m.omp, 'aauthname', '')

*!* FABRIC

m.json = mr_getfilefromzip(m.pfile, 'fabric.mod.json')

If Not Empty(m.json)

   m.ojson = nfjsonread(m.json)

   If Type('m.ojson.name') = 'C'

      m.omp.aname = m.ojson.Name

   Endif

   If Type('m.ojson.authors[1]') = 'C'

      m.omp.aauthname = m.ojson.authors[1]

   Endif

   m.omp.modid = m.ojson.Id

Endif

*!* FORGE

If Empty(m.omp.modid)

   m.json = mr_getfilefromzip(m.pfile, 'mcmod.info')

   If Not Empty(m.json)

      m.ojson = nfjsonread(m.json)

      If Type('m.ojson.name') = 'C'

         m.omp.aname = m.ojson.Name

      Endif

   If Type('m.ojson.authorList[1]') = 'C'

      m.omp.aauthname = m.ojson.authorList[1]

   Endif

      If Type('m.ojson.array[1].modid') = 'C'

         For m.lnx = 1 To Alen(m.ojson.Array)

            m.omp.modid = m.omp.modid + m.ojson.Array[m.lnx].modid + '|'

         Endfor

         m.omp.modid = Rtrim(m.omp.modid, 1, '|')

      Endif

      If Type('m.ojson.modList[1].modid') = 'C'

         For m.lnx = 1 To Alen(m.ojson.modList)

            m.omp.modid = m.omp.modid + m.ojson.modList[m.lnx].modid + '|'

         Endfor

         m.omp.modid = Rtrim(m.omp.modid, 1, '|')

      Endif

   Endif

Endif

*!* RIFT

If Empty(m.omp.modid)

   m.json = mr_getfilefromzip(m.pfile, 'riftmod.json')

   If Not Empty(m.json)

      m.ojson = nfjsonread(m.json)

      m.omp.modid = m.ojson.Id

      If Type('m.ojson.name') = 'C'

         m.omp.aname = m.ojson.Name

      Endif

   If Type('m.ojson.authors[1]') = 'C'

      m.omp.aauthname = m.ojson.authors[1]

   Endif

   Endif

Endif

*!* LITEMOD

If Empty(m.omp.modid)

   m.json = mr_getfilefromzip(m.pfile, 'litemod.json')

   If Not Empty(m.json)

      m.ojson = nfjsonread(m.json)

      m.omp.modid = m.ojson.Id

      If Type('m.ojson.name') = 'C'

         m.omp.aname = m.ojson.Name
	     m.omp.modid = m.ojson.Name

      Endif

   If Type('m.ojson.author') = 'C'

      m.omp.aauthname = m.ojson.author

   Endif

   Endif

Endif


Return m.omp








