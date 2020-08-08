*!* mr_addonparse

lparameters paid, pajson

local avatar, nselect, ojson

m.nselect = select()

if not used('par_addons')

	use 'mr_addons' in 0 again shared alias 'par_addons'

endif

select 'par_addons'

if seek(m.paid, 'par_addons', 'aid') = .f.

	error 'PAID # PAR_ADDONS.AID'

endif

m.ojson = nfjsonread(m.pajson)

*!* TYPO IN JSON PROPERTY: "isexperiemental"

replace ;
	par_addons.asecid	  with m.ojson.categorysection_id, ;
	par_addons.asecname	  with m.ojson.categorysection_name, ;
	par_addons.asecptype  with m.ojson.categorysection_packagetype, ;
	par_addons.authorid	  with m.ojson.author_userid, ;
	par_addons.authorname with m.ojson.author_name, ;
	par_addons.adcreated  with m.ojson.datecreated, ;
	par_addons.admodified with m.ojson.datemodified, ;
	par_addons.slug		  with m.ojson.slug, ;
	par_addons.adreleased with m.ojson.datereleased in 'par_addons'

replace ;
	par_addons.adowncount with m.ojson.downloadcount, ;
	par_addons.agameid	  with m.ojson.gameid, ;
	par_addons.agamename  with m.ojson.gamename, ;
	par_addons.aisavail	  with iif(m.ojson.isavailable, 1, 0), ;
	par_addons.aisexperim with iif(m.ojson.isexperiemental, 1, 0), ;
	par_addons.aname	  with m.ojson.name, ;
	par_addons.apcatid	  with m.ojson.primarycategoryid, ;
	par_addons.astatus	  with m.ojson.status, ;
	par_addons.astatusnam with mr_getprojectstatusname(m.ojson.status) in 'par_addons'

*!* UPDATE AVATAR

if type('m.ojson.attachment_url') # 'U'

	if not m.ojson.attachment_url == par_addons.aurl then

		replace par_addons.aurl with m.ojson.attachment_url, par_addons.avatar with '' in 'par_addons'

	endif

endif

if empty(par_addons.avatar)

	m.avatar = mr_downloadresource(par_addons.aurl)

	m.avatar = _jpgresizecrop(m.avatar, 128, 128)

	replace par_addons.avatar with m.avatar in 'par_addons'

endif

use in 'par_addons'

_restorearea(m.nselect)







