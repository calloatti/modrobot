*!* mr_isaddonupdated

local winhttp as 'winhttp' of 'winhttp.vcx'
local addontimestapnew, addontimestapold, haresponse, isaddonupdated, result, url

m.isaddonupdated = .f.

m.addontimestapold = _inigetvalue('ADDON_TIMESTAMP', "2000-01-01T00:00:00.000Z")

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.option_enableredirects = .t.

m.url = mr_geturlapi() + '/addon/timestamp'

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(10)

enddo

m.haresponse = m.winhttp.responsestatus

if m.haresponse = 200

	m.addontimestapnew = alltrim(m.winhttp.getresponse(), 1, '"')

	_inisetvalue('ADDON_TIMESTAMP', m.addontimestapnew)

	if m.addontimestapnew # m.addontimestapold

		m.isaddonupdated = .t.

	endif

endif

return m.isaddonupdated