*!* mr_genmodlist_markdown

lparameters piguid

local eol, nselect, txt

m.nselect = select()

if not used('inst_gml')

	use 'mr_instances' again alias 'inst_gml' in 0

endif

if not used('addo_gml')

	use 'mr_addons' again alias 'addons_gml' in 0

endif

if not used('modids_gml')

	use 'mr_modids' again alias 'modids_gml' in 0

endif

if not used('mods_gml')

	use 'mr_mods' again alias 'mods_gml' in 0

	set order to tag 'filename1'

endif

m.eol = 0h20200d0a

= seek(m.piguid, 'inst_gml', 'iguid')

m.txt = '**Loader**' + m.eol + inst_gml.iminecraft + m.eol

if 'fabric' $ lower(inst_gml.iloader)

	m.txt = m.txt + '[' + inst_gml.iloader + '](https://fabricmc.net)' + m.eol

else

	m.txt = m.txt + inst_gml.iloader + m.eol

endif

m.txt = m.txt + m.eol + '**Mods**' + m.eol

select 'mods_gml'

set order to tag 'filename1'

scan for mods_gml.iguid = m.piguid

	*!* skip disabled mods

	if lower(justext(mods_gml.filename1)) = 'disabled'

		loop

	endif

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	= seek(mods_gml.modid, 'modids_gml', 'modid')

	*!* skip "API and Library" category for now

	if mods_gml.aid # 0 and addons_gml.apcatid = 421

		loop

	endif

	= mr_genmodlist_markdown_doitem(@m.txt, m.eol)

endscan

m.txt = m.txt + m.eol + '**APIs/LIBs**' + m.eol

scan for mods_gml.iguid = m.piguid

	*!* skip disabled mods

	if lower(justext(mods_gml.filename1)) = 'disabled'

		loop

	endif

	if mods_gml.aid = 0

		loop

	endif

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	if  addons_gml.apcatid # 421

		loop

	endif

	= mr_genmodlist_markdown_doitem(@m.txt, m.eol)

endscan

*!* DISABLED MODS

m.txt = m.txt + m.eol + '**DISABLED**' + m.eol

scan for mods_gml.iguid = m.piguid and justext(mods_gml.filename1) = 'disabled'

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	= seek(mods_gml.modid, 'modids_gml', 'modid')

	= mr_genmodlist_markdown_doitem(@m.txt, m.eol)

endscan


use in 'inst_gml'

use in 'mods_gml'

use in 'addons_gml'

use in 'modids_gml'

_restorearea(m.nselect)

_cliptext = m.txt

messagebox('INSTANCE MODS LIST (MARKDOWN) COPIED TO CLIPBOARD', 64, 'MODROBOT')


procedure mr_genmodlist_markdown_doitem

lparameters ptxt, peol

local modfilename, modname, modurl


m.modname = alltrim(mods_gml.aname)

if empty(m.modname)

	m.modname = alltrim(proper(mods_gml.modid))

endif

m.modfilename = alltrim(mods_gml.filename1)

m.modurl = mr_geturlproject(mods_gml.aid)

if empty(m.modurl)

	m.modurl = alltrim(modids_gml.url)

endif

if empty(m.modurl)

	m.ptxt = m.ptxt + '- ' + m.modname + ': ' + m.modfilename + m.peol

else

	m.ptxt = m.ptxt + '- [' + m.modname + ': ' + m.modfilename + '](' + m.modurl + ')' + m.peol

endif


endproc











