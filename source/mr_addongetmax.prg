*!* mr_addongetmax

local winhttp as 'winhttp' of 'winhttp.vcx'
local aidmax, citem, encoding, html, namewrapper, pslug, result, url

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .t.

*!* GET MAX aid

m.winhttp.option_enableredirects = .t.

m.url = mr_geturlprojectsnew(1)

m.winhttp.open('GET', m.url, .t.)

m.winhttp.setrequestheader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8')

m.winhttp.setrequestheader('Accept-Language', 'en-US,en;q=0.5')

m.winhttp.setrequestheader('user-agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0')

m.winhttp.setrequestheader('Upgrade-Insecure-Requests', '1')

_logwrite('GET LAST ADDON URL', m.url)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(50)

enddo

mr_winhttplog(m.winhttp)

_logwrite('RESULT', m.winhttp.responsestatus)

_cliptext = m.winhttp.getresponse()


if m.winhttp.responsestatus # 200 then

	return 0

endif

m.html = m.winhttp.getresponse()

m.html = m.winhttp.htmldecode(m.html)

m.citem = strextract(m.html, '<div class="lg:flex items-end hidden">', '</div>')

m.pslug = alltrim(justfname(strextract(m.citem, 'href="', '">')))

*!* WE HAVE THE NEWEST PROJECT SLUG, NOW GET PROJECT ID

m.url = mr_geturlproject(m.pslug)

_logwrite('GET LAST ADDON ID', m.url)

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(50)

enddo

mr_winhttplog(m.winhttp)

_logwrite('RESULT', m.winhttp.responsestatus)

if m.winhttp.responsestatus # 200 then

	return 0

endif

m.html = m.winhttp.getresponse()

m.html = m.winhttp.htmldecode(m.html)

m.aidmax = strextract(m.html, '<span>Project ID</span>', '</div>')

m.aidmax = strextract(m.aidmax, '<span>', '</span>')

m.aidmax = int(val(m.aidmax))

return m.aidmax