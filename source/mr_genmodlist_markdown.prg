*!* mr_genmodlist_markdown

lparameters piguid

local lf, nselect, txt

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

m.lf = 0h0d0a

= seek(m.piguid, 'inst_gml', 'iguid')

m.txt = '**Loader**' + 0h0d0a + inst_gml.iminecraft + m.lf

if 'fabric' $ lower(inst_gml.iloader)

	m.txt = m.txt + '[' + inst_gml.iloader + '](https://fabricmc.net)' + m.lf

else

	m.txt = m.txt + inst_gml.iloader + m.lf

endif

m.txt = m.txt + m.lf + '**Mods**' + m.lf

select 'mods_gml'

set order to tag 'filename1'

scan for mods_gml.iguid = m.piguid and not justext(mods_gml.filename1) = 'disabled'

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	= seek(mods_gml.modid, 'modids_gml', 'modid')

	if mods_gml.aid # 0 and addons_gml.apcatid = 421

		loop

	endif

	if mods_gml.aid = 0

		if not empty(modids_gml.url)

			m.txt = m.txt + '- [' + proper(mods_gml.modid) + ': ' + mods_gml.filename1 + '](' + modids_gml.url + ')' + m.lf

		else

			if empty(mods_gml.modid)

				m.txt = m.txt + '- ' + mods_gml.filename1 + m.lf

			else

				m.txt = m.txt + '- ' + proper(mods_gml.modid) + m.lf

			endif

		endif

	else

		m.txt = m.txt + '- [' + mods_gml.aname + ': ' + mods_gml.filename1 + '](' + mr_geturlproject(mods_gml.aid) + ')' + m.lf

	endif

endscan

m.txt = m.txt + m.lf + '**APIs/LIBs**' + m.lf

scan for mods_gml.iguid = m.piguid and not justext(mods_gml.filename1) = 'disabled'

	if mods_gml.aid = 0

		loop

	endif

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	if  addons_gml.apcatid # 421

		loop

	endif

	m.txt = m.txt + '- [' + mods_gml.aname + ': ' + mods_gml.filename1 + '](' + mr_geturlproject(mods_gml.aid) + ')' + m.lf

endscan

*!* DISABLED MODS

m.txt = m.txt + m.lf + '**DISABLED**' + m.lf

scan for mods_gml.iguid = m.piguid and justext(mods_gml.filename1) = 'disabled'

	= seek(mods_gml.aid, 'addons_gml', 'aid')

	= seek(mods_gml.modid, 'modids_gml', 'modid')

	if mods_gml.aid = 0

		if not empty(modids_gml.url)

			m.txt = m.txt + '- [' + proper(mods_gml.modid) + ': ' + mods_gml.filename1 + '](' + modids_gml.url + ')' + m.lf

		else

			if empty(mods_gml.modid)

				m.txt = m.txt + '- ' + mods_gml.filename1 + m.lf

			else

				m.txt = m.txt + '- ' + proper(mods_gml.modid) + m.lf

			endif

		endif

	else

		m.txt = m.txt + '- [' + mods_gml.aname + ': ' + mods_gml.filename1 + '](' + mr_geturlproject(mods_gml.aid) + ')' + m.lf

	endif

endscan



use in 'inst_gml'

use in 'mods_gml'

use in 'addons_gml'

use in 'modids_gml'

_restorearea(m.nselect)

_cliptext = m.txt

messagebox('INSTANCE MODS LIST (MARKDOWN) COPIED TO CLIPBOARD', 64, 'MODROBOT')




