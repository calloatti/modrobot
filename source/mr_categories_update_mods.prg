*!* mr_categories_update_mods

lparameters piguid

local categoryid, categoryname, cguid, lnx, nselect, ojson

m.nselect = select()

if not used('cuc_modc')

	use 'mr_mods_categories' again alias 'cuc_modc' in 0

endif

select 'cuc_modc'

scan for mr_mods_categories.iguid == m.piguid

	replace mr_mods_categories.iguid with '00000000'
	replace mr_mods_categories.cguid with '000000000000000000000000'

endscan

if not used('cuc_categories')

	use 'mr_categories' again alias 'cuc_categories' in 0

	set order to tag 'cnamepath' in 'cuc_categories'

endif

if not used('cuc_mods')

	use 'mr_mods' again alias 'cuc_mods' in 0

	set order to tag 'filename1' in 'cuc_mods'

endif

if not used('cuc_addons')

	use 'mr_addons' again alias 'cuc_addons' in 0

endif

select 'cuc_mods'

_logwrite('SCAN MODS TABLE START')

scan for cuc_mods.iguid == m.piguid

	if seek(cuc_mods.aid, 'cuc_addons', 'aid') = .f.

		m.categoryid   = 0
		m.categoryname = ''
		m.cguid		   = cuc_mods.rguid + strconv(_ubintoc(m.categoryid), 15)

		mr_categories_update_mods_append(m.cguid, m.categoryid, m.categoryname)

		loop

	endif

	if empty(cuc_addons.hajsonf)

		m.categoryid   = 0
		m.categoryname = ''
		m.cguid		   = cuc_mods.rguid + strconv(_ubintoc(m.categoryid), 15)

		mr_categories_update_mods_append(m.cguid, m.categoryid, m.categoryname)

		loop

	endif

	m.ojson = nfjsonread(_zlibuncompress(cuc_addons.hajsonf))

	for m.lnx = 1 to alen(m.ojson.categories)

		m.categoryid = m.ojson.categories(m.lnx).categoryid

		if cuc_mods.aid = 312289

			_logwrite(m.categoryid)

			?seek(m.categoryid, 'cuc_categories', 'categoryid')

		endif

		if seek(m.categoryid, 'cuc_categories', 'categoryid')

			m.categoryname = cuc_categories.cnamepath

		else

			m.categoryname = m.ojson.categories(m.lnx).name

		endif

		m.cguid	= cuc_mods.rguid + strconv(_ubintoc(m.categoryid), 15)

		mr_categories_update_mods_append(m.cguid, m.categoryid, m.categoryname)

	endfor

endscan

_logwrite('SCAN MODS TABLE END')

use in 'cuc_addons'
use in 'cuc_mods'
use in 'cuc_categories'
use in 'cuc_modc'

_restorearea(m.nselect)

procedure mr_categories_update_mods_append

lparameters pcguid, pcategoryid, pcategoryname

local nselect

m.nselect = select()

select 'cuc_modc'

if seek(m.pcguid, 'cuc_modc', 'cguid') = .f.

	locate for mr_mods_categories.iguid = '00000000'

	if not found('cuc_modc')

		append blank in 'cuc_modc'

	endif

	replace cuc_modc.cguid with m.pcguid in 'cuc_modc'

endif

replace cuc_modc.aid with cuc_mods.aid in 'cuc_modc'
replace cuc_modc.aname with cuc_mods.aname in 'cuc_modc'
replace cuc_modc.authorname with cuc_mods.authorname in 'cuc_modc'
replace cuc_modc.fid with cuc_mods.fid1 in 'cuc_modc'
replace cuc_modc.filename with cuc_mods.filename1 in 'cuc_modc'
replace cuc_modc.gver with cuc_mods.gver1 in 'cuc_modc'
replace cuc_modc.iguid with cuc_mods.iguid in 'cuc_modc'
replace cuc_modc.modid with cuc_mods.modid in 'cuc_modc'
replace cuc_modc.categoryid with m.pcategoryid in 'cuc_modc'
replace cuc_modc.categoryname with m.pcategoryname in 'cuc_modc'

_logwrite('ADD MOD', cuc_modc.filename, cuc_modc.categoryid, cuc_modc.categoryname)

_restorearea(m.nselect)

endproc


















