*!* mr_instanceadd

lparameters pifolder

local iguid, nselect, oidata

m.iguid = ''

m.nselect = select()

if not used('inst_add')

	use 'mr_instances' in 0 again shared alias 'inst_add'

endif

select 'inst_add'

locate for lower(inst_add.ifolder) == lower(m.pifolder)

if not found('inst_add')

	m.iguid =  mr_crc32(m.pifolder + sys(2015))

	m.oidata = mr_instancegetdata(m.pifolder)

	mr_appendblank('inst_add')

	replace inst_add.gver1 with '' in 'inst_add'
	replace inst_add.gver2 with '' in 'inst_add'
	replace inst_add.gverlong1 with '' in 'inst_add'
	replace inst_add.gverlong2 with '' in 'inst_add'
	replace inst_add.isrvfolder with '' in 'inst_add'
	replace inst_add.itwifolder with '' in 'inst_add'
	replace inst_add.izipfolder with '' in 'inst_add'

	replace inst_add.iguid with m.iguid in 'inst_add'
	replace inst_add.ifolder with m.pifolder in 'inst_add'
	replace inst_add.iname with m.oidata.iname in 'inst_add'
	replace inst_add.iminecraft with m.oidata.iminecraft in 'inst_add'
	replace inst_add.iloader with m.oidata.iloader in 'inst_add'

	if empty(inst_add.icfdata)

		replace inst_add.icfdata with '"name": "CurseForgeModpackName"' + 0h0d0a + '"version": "CurseForgeModpackVersion"' + 0h0d0a + '"author": "CurseForgeAuthorName"' in 'inst_add'

	endif

	m.iguid = inst_add.iguid

endif

use in 'inst_add'

_restorearea(m.nselect)

return m.iguid