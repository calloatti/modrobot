*!* mr_addonfilesgetnew

Local winhttp as 'winhttp' OF 'winhttp.vcx'
Local encoding, fjson, fresponse, nselect, result, url

m.nselect = Select()

If Not Used('mr_addons_fgn')

	Use 'mr_addons' In 0 Again Shared Order Tag 'aid' Alias 'mr_addons_fgn'

Endif

m.winhttp = Newobject('winhttp', 'winhttp.vcx')

If Application.StartMode = 0

	*m.winhttp.setproxy(2, 'localhost:8888')

Endif

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

Select 'mr_addons_fgn'

*!* ONLY DO MINECRAFT MODS

Scan &&For mr_addons_fgn.gameid = 432 And mr_addons_fgn.acsptype = 5


	*!* ONLY ADDONS THAT HAVE ADDON AJSON

	If mr_addons_fgn.aresponse # 200 Then

		Loop

	Endif

	*!* NO UPDATING FJSON HERE

	If mr_addons_fgn.fresponse > 0 Then

		Loop

	Endif

	?mr_addons_fgn.aid

	m.url = 'https://addons-ecs.forgesvc.net/api/v2/addon/' + Transform(mr_addons_fgn.aid) + '/files'

	m.winhttp.Open('GET', m.url, .T.)

	m.winhttp.setrequestheader('Accept-Encoding', 'gzip')

	m.result = m.winhttp.Send()

	Do While m.winhttp.waitforresponse(0) = 0

		DoEvents

		_apisleep(20)

	Enddo

	m.fresponse = m.winhttp.responsestatus

	*!* IF NO INTERNET, SKIP

	If m.fresponse = 0 Then

		Loop

	Endif

	*!* ONLY IF SUCESS UPDATE DATA

	If m.fresponse = 200

		m.encoding = m.winhttp.getresponseheader('Content-Encoding')

		If 'gzip' $ m.encoding Then

			m.fjson = _zlibuncompressgzip(m.winhttp.responsebody)

		Else

			m.fjson = m.winhttp.responsetext

		Endif

		Replace mr_addons_fgn.fjson With m.fjson In 'mr_addons_fgn'

	Endif

	*!* UPDATE GET FIELDS

	Replace mr_addons_fgn.fresponse With m.fresponse, mr_addons_fgn.fdatetime With Datetime() In 'mr_addons_fgn'

	DoEvents

Endscan

Use In 'mr_addons_fgn'


Select (m.nselect)


 