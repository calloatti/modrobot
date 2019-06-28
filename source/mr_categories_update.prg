*!* mr_categories_update

Local winhttp as 'winhttp' OF 'winhttp.vcx'
Local cnamepath, lnx, nselect, ojson, parentid, result, slugpath, url

m.nselect = Select()

If Not Used('cat_upd')

   Use 'mr_categories' Again Alias 'cat_upd' In 0

Endif

If Not Used('cat_seek')

   Use 'mr_categories' Again Alias 'cat_seek' In 0

Endif

m.url = mr_geturlapi_category()

_logwrite('CATEGORIES UPDATE START')

m.winhttp = Newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .T.

m.winhttp.option_enableredirects = .T.

m.winhttp.Open('GET', m.url, .T.)

m.result = m.winhttp.Send()

Do While m.winhttp.waitforresponse(0) = 0

   DoEvents

   _apisleep(10)

Enddo

If m.winhttp.responsestatus = 200

   m.ojson = nfjsonread(m.winhttp.getresponse())

   If Type('m.ojson.array[1]') = 'O'

      For m.lnx = 1 To Alen(m.ojson.Array)

         If m.ojson.Array[m.lnx].gameid # 432

            Loop

         Endif

         _logwrite('UPDATE CATEGORY', m.ojson.Array[m.lnx].Name)

         If Seek(m.ojson.Array[m.lnx].Id, 'cat_upd', 'categoryid') = .F.

            Append Blank In 'cat_upd'

         Endif

         Select 'cat_upd'

         Replace ;
            cat_upd.categoryid With m.ojson.Array[m.lnx].Id, ;
            cat_upd.parentid With Nvl(m.ojson.Array[m.lnx].parentGameCategoryId, 0), ;
            cat_upd.rootid With Nvl(m.ojson.Array[m.lnx].rootGameCategoryId, 0), ;
            cat_upd.avatarurl With m.ojson.Array[m.lnx].avatarurl, ;
            cat_upd.cname With m.ojson.Array[m.lnx].Name, ;
            cat_upd.slug With m.ojson.Array[m.lnx].slug, ;
            cat_upd.gameid With m.ojson.Array[m.lnx].gameid In 'cat_upd'

         Select 'cat_upd'

         If Empty(cat_upd.avatar)

            Replace cat_upd.avatar With mr_downloadresource(cat_upd.avatarurl) In 'cat_upd'

         Endif

      Endfor

   Endif

Endif

Select 'cat_upd'

Scan

   m.cnamepath = cat_upd.cname

   m.slugpath = cat_upd.slug

   m.parentid = cat_upd.parentid

   Do While m.parentid # 0

      = Seek(m.parentid, 'cat_seek', 'categoryid')

      m.cnamepath = cat_seek.cname + '\' + m.cnamepath

      m.slugpath = cat_seek.slug + '/' + m.slugpath

      m.parentid = cat_seek.parentid

   Enddo

   Replace cat_upd.cnamepath With m.cnamepath In 'cat_upd'
   Replace cat_upd.slugpath With m.slugpath In 'cat_upd'

Endscan


Use In 'cat_upd'
Use In 'cat_seek'

_restorearea(m.nselect)

_logwrite('CATEGORIES UPDATE END')










 