*!* mr_avatardownload

Lparameters paid

Local winhttp As 'winhttp' Of 'winhttp'
Local imgdim, nselect

m.nselect = Select()

If Not Used('avatars_da')

   Use 'mr_avatars' In 0 Again Shared Alias 'avatars_da'

Endif

If Seek(m.paid, 'avatars_da', 'aid') = .T. And Not Empty(avatars_da.aurl) And Empty(avatars_da.avatar)

   _logwrite('AVATAR DOWNLOAD START', m.paid)

   m.winhttp = Newobject('winhttp', 'winhttp')

   *m.winhttp.setproxy(2, 'localhost:8888')

   m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

   m.winhttp.Open('GET', avatars_da.aurl, .T.)

   m.winhttp.Send()

   Do While m.winhttp.waitforresponse(0) = 0

      DoEvents

      _apisleep(50)

   Enddo

   If m.winhttp.responsestatus = 200

      Replace avatars_da.avatar With _jpgresizecrop(m.winhttp.responsebody, 128, 128) In 'avatars_da'

      m.imgdim = _getimagesize(avatars_da.avatar)

      Replace ;
         avatars_da.nh With m.imgdim.Height, ;
         avatars_da.nw With m.imgdim.Width, ;
         avatars_da.ns With m.imgdim.Size In 'avatars_da'

   Endif

   _logwrite('AVATAR DOWNLOAD END', m.paid)

Endif

Select(m.nselect)