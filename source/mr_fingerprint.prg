*!* mr_fingerprint

Lparameters pfingerprint

m.fingerprint = m.pfingerprint

If Vartype(m.fingerprint) = 'N'

   m.fingerprint = '[' + Transform(m.fingerprint) + ']'

Endif

If Not Left(m.fingerprint, 1) == '['

   m.fingerprint = '[' + m.fingerprint

Endif

If Not Right(m.fingerprint, 1) == ']'

   m.fingerprint = m.fingerprint + ']'

Endif

m.aid = 0

_logwrite('FINGERPRINT START')

m.winhttp = Newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

m.winhttp.option_enableredirects = .T.

m.url = 'https://addons-ecs.forgesvc.net/api/v2/fingerprint'

m.winhttp.Open('POST', m.url, .T.)

m.winhttp.setrequestheader('Accept', 'application/json')
m.winhttp.setrequestheader('Content-Type', 'application/json')

m.result = m.winhttp.Send(m.fingerprint)

Do While m.winhttp.waitforresponse(0) = 0

   DoEvents

   _apisleep(50)

Enddo

If m.winhttp.responsestatus = 200 Then

   Public ojson

   m.ojson = nfjsonread(m.winhttp.responsetext)

   If Type('m.ojson.exactmatches[1].id') # 'U'

      m.aid = m.ojson.exactmatches[1].Id

   Endif

Endif

_logwrite('FINGERPRINT END')

Return m.aid