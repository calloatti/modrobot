*!* mr_addonupdate

lparameters paid

local winhttp as 'winhttp' of 'winhttp.vcx'
local dofileupdate, fjson, hajson, haresponse, nselect, ojson, result, url

if empty(m.paid)

	return

endif

m.nselect = select()

if not used('upd_addons')

	use 'mr_addons' in 0 again shared order tag 'aid' descending alias 'upd_addons'

endif

select 'upd_addons'

if seek(m.paid, 'upd_addons', 'aid') = .f. then

	append blank in 'upd_addons'

	replace upd_addons.aid with m.paid in 'upd_addons'

endif

_logwrite('ADDON UPDATE START', m.paid)

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .t.

m.winhttp.option_enableredirects = .t.

m.url = mr_geturlapi_addon(upd_addons.aid)

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(10)

enddo

m.haresponse = m.winhttp.responsestatus

_logwrite('ADDON UPDATE API RESULT', m.winhttp.responsestatus)

if m.haresponse = 200

	m.hajson = m.winhttp.getresponse()

	m.hajson = mr_addonflatten(m.hajson)

	m.ojson = nfjsonread(m.hajson)

	*!* FORCE ALL UPDATES NOT MATTER WHAT, CF API BEING STUPID AND FAILING RANDOMLY 2020/08/12

	*!*	if m.ojson.datereleased > upd_addons.adreleased

	*!*		m.dofileupdate = .t.

	*!*	else

	*!*		m.dofileupdate = .f.

	*!*	endif

	*!*	*!* FORCE FILE UPDATE 2020/01/20

	*!* m.dofileupdate = .t.

	*!*	if m.ojson.datemodified > upd_addons.admodified

	replace upd_addons.hajson with _zlibcompress(m.hajson) in 'upd_addons'

	mr_addonparse(upd_addons.aid, m.hajson)

	*!*	endif

endif

*!* UPDATE GET FIELDS

replace upd_addons.haresponse with m.haresponse, upd_addons.hadatetime with datetime() in 'upd_addons'

_logwrite('ADDON UPDATE END', m.paid)

*!* GET FILES

*!* if m.dofileupdate = .t. and upd_addons.agameid = 432

if upd_addons.agameid = 432

	m.fjson = mr_filegetjson(upd_addons.aid)

	if not empty(m.fjson)

		mr_fileparse(upd_addons.aid, m.fjson, upd_addons.aname, upd_addons.slug, upd_addons.authorname)

	endif

endif

use in 'upd_addons'

_restorearea(m.nselect)


