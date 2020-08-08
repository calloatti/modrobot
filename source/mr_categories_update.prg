*!* mr_categories_update

local winhttp as 'winhttp' of 'winhttp.vcx'
local cnamepath, lnx, nselect, ojson, parentid, result, slugpath, url

m.nselect = select()

if not used('upd_categories')

	use 'mr_categories' again alias 'upd_categories' in 0

endif

if not used('lut_categories')

	use 'mr_categories' again alias 'lut_categories' in 0

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

			if seek(m.ojson.array[m.lnx].id, 'upd_categories', 'categoryid') = .f.

				append blank in 'upd_categories'

			endif

			select 'upd_categories'

			replace ;
				upd_categories.categoryid with	m.ojson.array[m.lnx].id, ;
				upd_categories.parentid   with	nvl(m.ojson.array[m.lnx].parentgamecategoryid, 0), ;
				upd_categories.rootid	  with	nvl(m.ojson.array[m.lnx].rootgamecategoryid, 0), ;
				upd_categories.avatarurl  with	m.ojson.array[m.lnx].avatarurl, ;
				upd_categories.cname	  with	m.ojson.array[m.lnx].name, ;
				upd_categories.slug	      with	m.ojson.array[m.lnx].slug, ;
				upd_categories.gameid	  with	m.ojson.array[m.lnx].gameid in 'upd_categories'

			select 'upd_categories'

			if empty(upd_categories.avatar)

				replace upd_categories.avatar with mr_downloadresource(upd_categories.avatarurl) in 'upd_categories'

			endif

		endfor

	endif

endif

select 'upd_categories'

scan

	m.cnamepath	= upd_categories.cname
	m.slugpath	= upd_categories.slug
	m.parentid	= upd_categories.parentid

	do while m.parentid # 0

		= seek(m.parentid, 'lut_categories', 'categoryid')

		m.cnamepath	= lut_categories.cname + '\' + m.cnamepath
		m.slugpath	= lut_categories.slug + '/' + m.slugpath
		m.parentid	= lut_categories.parentid

	enddo

	replace upd_categories.cnamepath with m.cnamepath in 'upd_categories'
	replace upd_categories.slugpath  with m.slugpath in 'upd_categories'

endscan


use in 'upd_categories'
use in 'lut_categories'

_restorearea(m.nselect)

_logwrite('CATEGORIES UPDATE END')