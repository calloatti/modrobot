*!* mr_genmodlist_markdown

Lparameters piguid

Local lf, nselect, txt

m.nselect = Select()

If Not Used('inst_gml')

   Use 'mr_instances' Again Alias 'inst_gml' In 0

Endif

If Not Used('addo_gml')

   Use 'mr_addons' Again Alias 'addons_gml' In 0

Endif

If Not Used('other_gml')

   Use 'mr_othermods' Again Alias 'other_gml' In 0

Endif

If Not Used('mods_gml')

   Use 'mr_mods' Again Alias 'mods_gml' In 0

   Set Order To Tag 'filename1'

Endif

m.lf = 0h0d0a

= Seek(m.piguid, 'inst_gml', 'iguid')

m.txt = '**Loader**' + 0h0d0a + inst_gml.iminecraft + m.lf

If 'fabric' $ Lower(inst_gml.iloader)

   m.txt = m.txt + '[' + inst_gml.iloader + '](https://fabricmc.net)' + m.lf

Else

   m.txt = m.txt + inst_gml.iloader + m.lf

Endif

m.txt = m.txt + m.lf + '**Mods**' + m.lf

Select 'mods_gml'

Set Order To Tag 'filename1'

Scan For mods_gml.iguid = m.piguid And Not Justext(mods_gml.filename1) = 'disabled'

   = Seek(mods_gml.aid, 'addons_gml', 'aid')

   = Seek(mods_gml.modid, 'other_gml', 'modid')

   If mods_gml.aid # 0 And addons_gml.apcatid = 421

      Loop

   Endif

   If mods_gml.aid = 0

      If Not Empty(other_gml.url)

         m.txt = m.txt + '- [' + Proper(mods_gml.modid) + ': ' + mods_gml.filename1 + '](' + other_gml.url + ')' + m.lf

      Else

         If Empty(mods_gml.modid)

            m.txt = m.txt + '- ' + mods_gml.filename1 + m.lf

         Else

            m.txt = m.txt + '- ' + Proper(mods_gml.modid) + m.lf

         Endif

      Endif

   Else

      m.txt = m.txt + '- [' + mods_gml.aname + ': ' + mods_gml.filename1 + '](' + mr_geturlproject(mods_gml.aid) + ')' + m.lf

   Endif

Endscan

m.txt = m.txt + m.lf + '**APIs/LIBs**' + m.lf

Scan For mods_gml.iguid = m.piguid And Not Justext(mods_gml.filename1) = 'disabled'

   If mods_gml.aid = 0

      Loop

   Endif

   = Seek(mods_gml.aid, 'addons_gml', 'aid')

   If  addons_gml.apcatid # 421

      Loop

   Endif

   m.txt = m.txt + '- [' + mods_gml.aname + ': ' + mods_gml.filename1 + '](' + mr_geturlproject(mods_gml.aid) + ')' + m.lf

Endscan

Use In 'inst_gml'

Use In 'mods_gml'

Use In 'addons_gml'

Use In 'other_gml'

_restorearea(m.nselect)

_Cliptext = m.txt

Messagebox('INSTANCE MODS LIST (MARKDOWN) COPIED TO CLIPBOARD', 64, 'MODROBOT')




  