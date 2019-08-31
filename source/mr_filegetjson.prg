*!* mr_filegetjson

lparameters paid

local winhttp as 'winhttp' of 'winhttp.vcx'
local json, result, url

doevents

_logwrite('GET FILES JSON', m.paid)

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .t.

m.winhttp.option_enableredirects = .t.

m.url = mr_geturlapi_addon_files(m.paid)

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(10)

enddo

*!* ONLY IF SUCESS UPDATE DATA

if m.winhttp.responsestatus = 200

	m.json = m.winhttp.getresponse()

else

	m.json = ''

endif

return m.json