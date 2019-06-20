*!* mr_getmodid

Lparameters pfile

Local json, lnx, modid, ojson

m.modid = ''

m.json = mr_getfilefromzip(m.pfile, 'fabric.mod.json')

If Not Empty(m.json)

   m.ojson = nfjsonread(m.json)

   m.modid = m.ojson.Id

Endif

If Empty(m.modid)

   m.json = mr_getfilefromzip(m.pfile, 'mcmod.info')

   If Not Empty(m.json)

      m.ojson = nfjsonread(m.json)

      If Type('m.ojson.array[1].modid') = 'C'

         For m.lnx = 1 To Alen(m.ojson.Array)

            m.modid = m.modid + m.ojson.Array[m.lnx].modid + '|'

         Endfor

         m.modid = Rtrim(m.modid, 1, '|')

      Endif

      If Type('m.ojson.modList[1].modid') = 'C'

         For m.lnx = 1 To Alen(m.ojson.modList)

            m.modid = m.modid + m.ojson.modList[m.lnx].modid + '|'

         Endfor

         m.modid = Rtrim(m.modid, 1, '|')

      Endif

   Endif

Endif

Return m.modid







