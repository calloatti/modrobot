*!* mr_instanceupdate

lparameters piguid, pifolder

_logwrite('INSTANCE UPDATE START')

m.nselect = select()

if not used('inst_upd')

	use 'mr_instances' in 0 again shared alias 'inst_upd'

endif

select 'inst_upd'

if seek(m.piguid, 'inst_upd', 'iguid') = .t.

	if not empty(m.pifolder)

		replace inst_upd.ifolder with m.pifolder in 'inst_upd'

	endif

	m.oidata = mr_instancegetdata(inst_upd.ifolder)

	replace inst_upd.iname with m.oidata.iname in 'inst_upd'
	replace inst_upd.iminecraft with m.oidata.iminecraft in 'inst_upd'
	replace inst_upd.iloader with m.oidata.iloader in 'inst_upd'

	if empty(inst_upd.icfdata)

		replace inst_upd.icfdata with '"name": "CurseForgeModpackName"' + 0h0d0a + '"version": "CurseForgeModpackVersion"' + 0h0d0a + '"author": "CurseForgeAuthorName"' in 'inst_upd'

	endif

endif

use in 'inst_upd'

_restorearea(m.nselect)

_logwrite('INSTANCE UPDATE END')
