*!* mr_pastedelete

Lparameters purl

Local winhttp As 'winhttp' Of 'winhttp'
Local token, url

If Not Used('pastes_del')

   Use 'mr_pastes' Again Alias 'pastes_del' In 0

Endif

If Seek(m.purl, 'pastes_del', 'purl') = .T.

   m.winhttp = Newobject('winhttp', 'winhttp')

   m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

   *m.winhttp.setproxy(2, 'localhost:8888')

   m.url = 'https://api.paste.ee/v1/pastes/' + Justfname(pastes_del.purl)

   m.token = mr_pastegettoken()

   m.winhttp.Open('DELETE', m.url, .T.)

   m.winhttp.setrequestheader('User-Agent', 'modrobot')
   m.winhttp.setrequestheader('Content-Type', 'application/json')
   m.winhttp.setrequestheader('X-Auth-Token', m.token)

   m.winhttp.Send()

   Do While m.winhttp.waitforresponse(0) = 0

      DoEvents

      _apisleep(50)

   Enddo

   *!* "success":true

   ?m.winhttp.responsetext
   ?m.winhttp.responsestatus

Endif