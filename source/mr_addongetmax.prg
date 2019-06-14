*!* mr_addongetmax

Local winhttp as 'winhttp' Of 'winhttp.vcx'
Local aidmax, citem, encoding, html, namewrapper, pslug, result, url

m.winhttp = Newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .T.

*!* GET MAX aid

m.winhttp.option_enableredirects = .T.

m.url = curse_geturlprojectsnew(1)

m.winhttp.Open('GET', m.url, .T.)

_logwrite('GET LAST ADDON URL', m.url)

m.result = m.winhttp.Send()

Do While m.winhttp.waitforresponse(0) = 0

	DoEvents

	_apisleep(50)

Enddo

_logwrite('RESULT', m.winhttp.responsestatus)

If m.winhttp.responsestatus # 200 Then

	Return

Endif

m.html = m.winhttp.getresponse()

m.html = m.winhttp.htmldecode(m.html)

m.citem = Strextract(m.html, '<li class="project-list-item">', '</li>')

m.namewrapper = Strextract(m.citem, '<div class="name-wrapper overflow-tip">', '</div>')

m.pslug = Alltrim(Justfname(Strextract(m.namewrapper, '<a href="', '">')))

*!* WE HAVE THE NEWEST PROJECT SLUG, NOW GET PROJECT ID

m.url = curse_geturlproject(m.pslug)

_logwrite('GET LAST ADDON ID', m.url)

m.winhttp.Open('GET', m.url, .T.)

m.result = m.winhttp.Send()

Do While m.winhttp.waitforresponse(0) = 0

	DoEvents

	_apisleep(50)

Enddo

_logwrite('RESULT', m.winhttp.responsestatus)

If m.winhttp.responsestatus # 200 Then

	Return

Endif

m.html = m.winhttp.getresponse()

m.html = m.winhttp.htmldecode(m.html)

m.aidmax = Int(Val(Strextract(Strextract(m.html, '<div class="info-label">Project ID', '</li>'), '<div class="info-data">', '</div>')))

Return m.aidmax  