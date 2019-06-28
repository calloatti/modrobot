*!* mr_downloadstring

Lparameters purl

Local winhttp as 'winhttp' OF 'winhttp'
Local bytes

m.winhttp = Newobject('winhttp', 'winhttp')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

m.winhttp.Open('GET', m.purl, .T.)

m.winhttp.gzip = .t.

m.winhttp.Send()

Do While m.winhttp.waitforresponse(0) = 0

   DoEvents

   _apisleep(50)

Enddo

If m.winhttp.responsestatus = 200

   m.bytes = m.winhttp.getresponse()

Else

   m.bytes = ''

Endif

Return m.bytes 