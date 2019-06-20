*!* mr_addonparse

Lparameters paid, pajson

Local aauthname, aauthorsid, asecid, asecname, asecptype, aurl, lnx, nselect, ojson

If Empty(m.pajson)

   Return

Endif

m.nselect = Select()

If Not Used('addons_pja')

   Use 'mr_addons' Again Alias 'addons_pja' In 0

Endif

If Seek(m.paid, 'addons_pja', 'aid') = .F. Then

   _restorearea(m.nselect)

   Return

Endif

If Not Used('categories_pja')

   Use 'mr_categories' Again Alias 'categories_pja' In 0

Endif

If Not Used('avatars_pja')

   Use 'mr_avatars' Again Alias 'avatars_pja' In 0

Endif

If Not Used('pstatus_pja')

   Use 'mr_enum_projectstatus' Again Alias 'pstatus_pja' In 0

Endif

_logwrite('ADDON PARSE START', m.paid)

m.ojson = nfjsonread(m.pajson)

If Type('m.ojson.authors[1].Id') # 'U'

   m.aauthorsid	= m.ojson.authors[1].Id
   m.aauthname	= m.ojson.authors[1].Name

Else

   m.aauthorsid	= ''
   m.aauthname	= ''

Endif

If Type('m.ojson.categorysection.Id') # 'U'

   m.asecid	   = m.ojson.categorysection.Id
   m.asecname  = m.ojson.categorysection.Name
   m.asecptype = m.ojson.categorysection.packagetype

Else

   m.asecid	   = 0
   m.asecname  = ''
   m.asecptype = 0

Endif

*!* TYPO IN JSON PROPERTY: "isexperiemental"

Replace ;
   addons_pja.asecid With m.asecid, ;
   addons_pja.asecname With m.asecname, ;
   addons_pja.asecptype With m.asecptype, ;
   addons_pja.aauthorsid With m.aauthorsid, ;
   addons_pja.aauthname With m.aauthname, ;
   addons_pja.adcreated With m.ojson.datecreated, ;
   addons_pja.admodified With m.ojson.datemodified, ;
   addons_pja.adreleased With m.ojson.datereleased In 'addons_pja'


Replace ;
   addons_pja.adowncount With m.ojson.downloadcount, ;
   addons_pja.agameid With m.ojson.gameid, ;
   addons_pja.agamename With m.ojson.gamename, ;
   addons_pja.aisavail With Iif(m.ojson.isavailable, 1, 0), ;
   addons_pja.aisexperim With Iif(m.ojson.isexperiemental, 1, 0), ;
   addons_pja.aname With m.ojson.Name, ;
   addons_pja.apcatid With m.ojson.primarycategoryid, ;
   addons_pja.astatus With m.ojson.Status In 'addons_pja'

If Seek(addons_pja.astatus, 'pstatus_pja', 'eid') = .T.

   Replace addons_pja.astatusnam With pstatus_pja.ename In 'addons_pja'

Endif

*!* SAVE AVATAR URL ONLY FOR MINECRAFT GAMES

If m.ojson.gameid = 432 And Type('m.ojson.attachments[1]') = 'O'

   For m.lnx = 1 To Alen(m.ojson.attachments)

      If m.ojson.attachments[m.lnx].isDefault = .T. Then

         If Seek(m.paid, 'avatars_pja', 'aid') = .F.

            Append Blank In 'avatars_pja'

            Replace avatars_pja.aid With m.paid In 'avatars_pja'

         Endif

         m.aurl = m.ojson.attachments[m.lnx].thumbnailUrl

         If Empty(m.aurl)

            m.aurl = m.ojson.attachments[m.lnx].url

         Endif

         *!* ONLY IF AVATAR URL CHANGED

         If Not m.aurl == avatars_pja.aurl

            Replace avatars_pja.aurl With m.aurl In 'avatars_pja'

            Replace avatars_pja.avatar With ''  In 'avatars_pja'

         Endif

         mr_avatardownload(m.paid)

         Exit

      Endif

   Endfor

Endif

*!* CATEGORIES

If Type('m.ojson.categories[1]') = 'O'

   For m.lnx = 1 To Alen(m.ojson.categories)

      If Seek(m.ojson.categories[m.lnx].categoryid, 'categories_pja', 'categoryid') = .F.

         Append Blank In 'categories_pja'

         Replace ;
            categories_pja.categoryid With m.ojson.categories[m.lnx].categoryid, ;
            categories_pja.avatarurl With m.ojson.categories[m.lnx].avatarurl, ;
            categories_pja.cname With m.ojson.categories[m.lnx].Name, ;
            categories_pja.gameid With m.ojson.categories[m.lnx].gameid In 'categories_pja'

         Replace categories_pja.avatar With mr_downloadresource(categories_pja.avatarurl) In 'categories_pja'

      Endif

   Endfor

Endif

_logwrite('ADDON PARSE END', m.paid)

Use In 'addons_pja'
Use In 'avatars_pja'
Use In 'pstatus_pja'
Use In 'categories_pja'

_restorearea(m.nselect)