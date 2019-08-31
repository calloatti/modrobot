*!* mr_addonflatten

lparameters pjson

local lnx, ojson

m.ojson = nfjsonread(m.pjson)

if type('m.ojson.latestfiles') # 'U'

	removeproperty(m.ojson, 'latestfiles')

endif

if type('m.ojson.gameversionlatestfiles') # 'U'

	removeproperty(m.ojson, 'gameversionlatestfiles')

endif

if type('m.ojson.categories') # 'U'

	removeproperty(m.ojson, 'categories')

endif

*!* was using authors.id as authorid, the proper id is authors.userid

addproperty(m.ojson, 'latestfiles', '')
addproperty(m.ojson, 'gameversionlatestfiles', '')
addproperty(m.ojson, 'categories', '')
addproperty(m.ojson, 'author_userid', 0)

addproperty(m.ojson, 'author_id', 0)

addproperty(m.ojson, 'author_name', '')

addproperty(m.ojson, 'attachment_id', 0)
addproperty(m.ojson, 'attachment_url', '')

addproperty(m.ojson, 'categorysection_gamecategoryid', 0)
addproperty(m.ojson, 'categorysection_gameid', 0)
addproperty(m.ojson, 'categorysection_id', 0)
addproperty(m.ojson, 'categorysection_name', '')
addproperty(m.ojson, 'categorysection_packagetype', 0)
addproperty(m.ojson, 'categorysection_path', '')

if type('m.ojson.authors') # 'U' and vartype(m.ojson.authors[1]) = 'O'

	m.ojson.author_userid = m.ojson.authors[1].userid
	m.ojson.author_id	  = m.ojson.authors[1].userid
	m.ojson.author_name	  = m.ojson.authors[1].name

	removeproperty(m.ojson, 'authors')

endif

if type('m.ojson.attachments') # 'U'

	for m.lnx = 1 to alen(m.ojson.attachments)

		if vartype(m.ojson.attachments[m.lnx]) = 'O' and m.ojson.attachments[m.lnx].isdefault = .t.

			m.ojson.attachment_id  = m.ojson.attachments[m.lnx].id
			m.ojson.attachment_url = m.ojson.attachments[m.lnx].url

			exit

		endif

	endfor

	removeproperty(m.ojson, 'attachments')

endif


if type('m.ojson.categorysection.Id') # 'U'

	m.ojson.categorysection_gamecategoryid = m.ojson.categorysection.gamecategoryid
	m.ojson.categorysection_gameid		   = m.ojson.categorysection.gameid
	m.ojson.categorysection_id			   = m.ojson.categorysection.id
	m.ojson.categorysection_name		   = m.ojson.categorysection.name
	m.ojson.categorysection_packagetype	   = m.ojson.categorysection.packagetype
	m.ojson.categorysection_path		   = m.ojson.categorysection.path

endif

removeproperty(m.ojson, 'categorysection')

return nfjsoncreate(m.ojson)