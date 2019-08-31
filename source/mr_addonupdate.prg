*!* mr_addonupdate

lparameters paid

Local winhttp as 'winhttp' OF 'winhttp.vcx'
Local dofileupdate, fjson, hajson, haresponse, nselect, ojson, result, url

if empty(m.paid)

	return

endif

m.nselect = select()

if not used('addons_upd')

	use 'mr_addons' in 0 again shared order tag 'aid' descending alias 'addons_upd'

endif

select 'addons_upd'

if seek(m.paid, 'addons_upd', 'aid') = .f. then

	append blank in 'addons_upd'

	replace addons_upd.aid with m.paid in 'addons_upd'

endif

_logwrite('PROJECT UPDATE', m.paid)

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .t.

m.winhttp.option_enableredirects = .t.

m.url = mr_geturlapi_addon(addons_upd.aid)

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(10)

enddo

m.haresponse = m.winhttp.responsestatus

if m.haresponse = 200

	m.hajson = m.winhttp.getresponse()

	m.hajson = mr_addonflatten(m.hajson)

	m.ojson = nfjsonread(m.hajson)

	if m.ojson.datereleased > addons_upd.adreleased

		m.dofileupdate = .t.

	else

		m.dofileupdate = .f.

	endif

	if m.ojson.datemodified > addons_upd.admodified

		replace addons_upd.hajson with _zlibcompress(m.hajson) in 'addons_upd'

		mr_addonparse(addons_upd.aid, m.hajson)

	endif

endif

*!* UPDATE GET FIELDS

replace addons_upd.haresponse with m.haresponse, addons_upd.hadatetime with datetime() in 'addons_upd'

*!* GET FILES

if m.dofileupdate = .t. and addons_upd.agameid = 432

	m.fjson = mr_filegetjson(addons_upd.aid)

	if not empty(m.fjson)

		mr_fileparse(addons_upd.aid, m.fjson, addons_upd.aname, addons_upd.slug, addons_upd.authorname)

	endif

endif

use in 'addons_upd'

_restorearea(m.nselect)

  