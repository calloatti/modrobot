*!* mr_modloaders_update

Local winhttp as 'winhttp' OF 'winhttp.vcx'
Local lnx, nselect, ojson, result, url

m.nselect = select()

if not used('modl_upd')

	use 'mr_modloaders' again alias 'modl_upd' in 0

endif

m.url = mr_geturlapi_modloader()

_logwrite('MODLOADERS UPDATE START')

m.winhttp = newobject('winhttp', 'winhttp.vcx')

*m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.settimeouts(60000, 60000, 30000, 60000)

m.winhttp.gzip = .t.

m.winhttp.option_enableredirects = .t.

m.winhttp.open('GET', m.url, .t.)

m.result = m.winhttp.send()

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(10)

enddo

select 'modl_upd'

if m.winhttp.responsestatus = 200

	_cliptext = m.winhttp.getresponse()

	m.ojson = nfjsonread(m.winhttp.getresponse())

	if type('m.ojson.array[1]') = 'O'

		for m.lnx = 1 to alen(m.ojson.array)

			_logwrite('UPDATE MODLOADER', m.ojson.array[m.lnx].name)

			if seek(m.ojson.array[m.lnx].name, 'modl_upd', 'mname') = .f.

				append blank in 'modl_upd'

			endif

			replace ;
				modl_upd.gver     with	m.ojson.array[m.lnx].gameversion, ;
				modl_upd.gverlong with	mr_getgameversionlong(m.ojson.array[m.lnx].gameversion), ;
				modl_upd.mdate	  with	m.ojson.array[m.lnx].datemodified, ;
				modl_upd.mlatest  with	m.ojson.array[m.lnx].latest, ;
				modl_upd.mname	  with	m.ojson.array[m.lnx].name, ;
				modl_upd.mreco	  with	m.ojson.array[m.lnx].recommended in 'modl_upd'

		endfor

	endif

endif

use in 'modl_upd'

_restorearea(m.nselect)

_logwrite('MODLOADERS UPDATE END')
















 