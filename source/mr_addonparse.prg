*!* mr_addonparse

*!* THIS ASSUMES THE ADDONS TABLE IS OPEN (addons_upd) AND POSITIONED ON THE RECORD TO BE UPDATED

lparameters paid, pajson

local avatar, ojson

if m.paid # addons_upd.aid or m.paid = 0

	error 'PAID'

endif

m.ojson = nfjsonread(m.pajson)

*!* TYPO IN JSON PROPERTY: "isexperiemental"

replace ;
	addons_upd.asecid	  with m.ojson.categorysection_id, ;
	addons_upd.asecname	  with m.ojson.categorysection_name, ;
	addons_upd.asecptype  with m.ojson.categorysection_packagetype, ;
	addons_upd.authorid   with m.ojson.author_userid, ;
	addons_upd.authorname with m.ojson.author_name, ;
	addons_upd.adcreated  with m.ojson.datecreated, ;
	addons_upd.admodified with m.ojson.datemodified, ;
	addons_upd.slug		  with m.ojson.slug, ;
	addons_upd.adreleased with m.ojson.datereleased in 'addons_upd'

replace ;
	addons_upd.adowncount with m.ojson.downloadcount, ;
	addons_upd.agameid	  with m.ojson.gameid, ;
	addons_upd.agamename  with m.ojson.gamename, ;
	addons_upd.aisavail	  with iif(m.ojson.isavailable, 1, 0), ;
	addons_upd.aisexperim with iif(m.ojson.isexperiemental, 1, 0), ;
	addons_upd.aname	  with m.ojson.name, ;
	addons_upd.apcatid	  with m.ojson.primarycategoryid, ;
	addons_upd.astatus	  with m.ojson.status, ;
	addons_upd.astatusnam with mr_getprojectstatusname(m.ojson.status) in 'addons_upd'

*!* UPDATE AVATAR

if type('m.ojson.attachment_url') # 'U'

	if not m.ojson.attachment_url == addons_upd.aurl then

		replace addons_upd.aurl with m.ojson.attachment_url, addons_upd.avatar with '' in 'addons_upd'

	endif

endif

if empty(addons_upd.avatar)

	m.avatar = mr_downloadresource(addons_upd.aurl)

	m.avatar = _jpgresizecrop(m.avatar, 128, 128)

	replace addons_upd.avatar with m.avatar in 'addons_upd'

endif

if empty(addons_upd.avatar)

	m.avatar = strconv('iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAMAAAD04JH5AAAAB3RJTUUH4wgdEBMaTqwclwAAAAlwSFlzAAAeeAAAHngBy6sDHwAAAARnQU1BAACxjwv8YQUAAAADUExURT8/P2b1mHYAAAAmSURBVHja7cEBAQAAAIIg/69uSEABAAAAAAAAAAAAAAAAAAAA7wZAgAABHoWnEwAAAABJRU5ErkJggg==', 14)

	replace addons_upd.avatar with m.avatar in 'addons_upd'

endif








