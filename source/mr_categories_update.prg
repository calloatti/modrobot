*!* mr_categories_update

local winhttp as 'winhttp' of 'winhttp.vcx'
local cnamepath, lnx, nselect, ojson, parentid, result, slugpath, url

m.nselect = select()

if not used('cat_upd')

	use 'mr_categories' again alias 'cat_upd' in 0

endif

if not used('cat_seek')

	use 'mr_categories' again alias 'cat_seek' in 0

endif

m.url = mr_geturlapi_category()

_logwrite('CATEGORIES UPDATE START')

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

if m.winhttp.responsestatus = 200

	m.ojson = nfjsonread(m.winhttp.getresponse())

	if type('m.ojson.array[1]') = 'O'

		for m.lnx = 1 to alen(m.ojson.array)

			if m.ojson.array[m.lnx].gameid # 432

				loop

			endif

			_logwrite('UPDATE CATEGORY', m.ojson.array[m.lnx].name)

			if seek(m.ojson.array[m.lnx].id, 'cat_upd', 'categoryid') = .f.

				append blank in 'cat_upd'

			endif

			select 'cat_upd'

			replace ;
					cat_upd.categoryid with	m.ojson.array[m.lnx].id, ;
					cat_upd.parentid   with	nvl(m.ojson.array[m.lnx].parentgamecategoryid, 0), ;
					cat_upd.rootid	   with	nvl(m.ojson.array[m.lnx].rootgamecategoryid, 0), ;
					cat_upd.avatarurl  with	m.ojson.array[m.lnx].avatarurl, ;
					cat_upd.cname	   with	m.ojson.array[m.lnx].name, ;
					cat_upd.slug	   with	m.ojson.array[m.lnx].slug, ;
					cat_upd.gameid	   with	m.ojson.array[m.lnx].gameid in 'cat_upd'

			select 'cat_upd'

			if empty(cat_upd.avatar)

				replace cat_upd.avatar with mr_downloadresource(cat_upd.avatarurl) in 'cat_upd'

			endif

		endfor

	endif

endif

select 'cat_upd'

scan

	m.cnamepath = cat_upd.cname

	m.slugpath = cat_upd.slug

	m.parentid = cat_upd.parentid

	do while m.parentid # 0

		= seek(m.parentid, 'cat_seek', 'categoryid')

		m.cnamepath = cat_seek.cname + '\' + m.cnamepath

		m.slugpath = cat_seek.slug + '/' + m.slugpath

		m.parentid = cat_seek.parentid

	enddo

	replace ;
			cat_upd.cnamepath with m.cnamepath, ;
			cat_upd.slugpath  with m.slugpath in 'cat_upd'

endscan


use in 'cat_upd'
use in 'cat_seek'

_restorearea(m.nselect)

_logwrite('CATEGORIES UPDATE END')













