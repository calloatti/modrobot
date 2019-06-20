*!* mr_instanceadd

Lparameters pfolder

Local cdata, cfile, ifolder, iguid, iloader, iminecraft, iname, lny, nselect, ojson


m.nselect = Select()

If Not Used('instance_add')

   Use 'mr_instances' In 0 Again Shared Alias 'instance_add'

Endif

m.iminecraft = ''
m.iloader	 = 'None'
m.iname		 = ''
m.ifolder	 = m.pfolder

m.cfile = Addbs(m.pfolder) + '..\..\instance.cfg'

If File(m.cfile)

   m.cdata = Chrtran(Filetostr(m.cfile), 0h0a, '|')

   m.iname = Strextract(m.cdata, 'name=', '|')

Endif

If Empty(m.iname)

   m.iname = Justfname(Justfname(Justfname(m.pfolder)))

Endif

m.cfile = Addbs(m.pfolder) + '..\..\mmc-pack.json'

If File(m.cfile)

   m.ojson = nfjsonread(Filetostr(m.cfile))

   If Type('m.ojson.components[1]') = 'O'

      For m.lny = 1 To Alen(m.ojson.components)

         Do Case

            Case m.ojson.components[m.lny].cachedname == 'Minecraft'

               m.iminecraft = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].Version

            Case m.ojson.components[m.lny].cachedname == 'Forge'

               m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].Version

            Case m.ojson.components[m.lny].cachedname == 'FabricLoader'

               m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].cachedversion

            Case m.ojson.components[m.lny].cachedname == 'Fabric Loader'

               m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].Version

         Endcase

      Endfor

   Endif

Endif

m.iguid =  mr_crc32(m.ifolder)

If Seek(m.iguid, 'instance_add', 'iguid') = .F.

   Append Blank In 'instance_add'

   Replace instance_add.iguid With m.iguid In 'instance_add'
   Replace instance_add.ifolder With m.ifolder In 'instance_add'

Endif

Replace instance_add.iname With m.iname In 'instance_add'
Replace instance_add.iminecraft With m.iminecraft In 'instance_add'
Replace instance_add.iloader With m.iloader In 'instance_add'

Use In 'instance_add'

_restorearea(m.nselect)

