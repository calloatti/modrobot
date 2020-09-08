*!* mr_instanceupdate

lparameters piguid, pifolder

Local ifolder, newblpath, nselect, oidata, oldblpath

_logwrite('INSTANCE UPDATE START')

m.nselect = select()

if not used('log_upd')

	use 'mr_log' in 0 again shared alias 'log_upd'

endif

if not used('blist_upd')

	use 'mr_blacklist' in 0 again shared alias 'blist_upd'

endif

if not used('inst_upd')

	use 'mr_instances' in 0 again shared alias 'inst_upd'

endif

if seek(m.piguid, 'inst_upd', 'iguid') = .t.

	m.ifolder = inst_upd.ifolder

	if not empty(m.pifolder)

		*!* UPDATE FOLDER IN INSTANCES

		select 'inst_upd'

		replace inst_upd.ifolder with m.pifolder in 'inst_upd'

		*!* UPDATE FOLDER IN LOG

		select 'log_upd'

		scan for log_upd.iguid = m.piguid

			replace log_upd.ifolder with strtran(log_upd.ifolder, m.ifolder, m.pifolder, 1, 1) in 'log_upd'

		endscan

		*!* UPDATE FOLDER IN BLACKLIST

		select 'blist_upd'

		m.oldblpath	= justpath(justpath(m.ifolder))
		m.newblpath	= justpath(justpath(m.pifolder))

		scan for blist_upd.iguid = m.piguid

			replace blist_upd.blpath with strtran(blist_upd.blpath, m.oldblpath, m.newblpath, 1, 1) in 'blist_upd'
			replace blist_upd.blmd5 with _md5hashstring(lower(blist_upd.blpath)) in 'blist_upd'

		endscan

	endif

	select 'inst_upd'

	m.oidata = mr_instancegetdata(inst_upd.ifolder)

	replace inst_upd.iname with m.oidata.iname in 'inst_upd'
	replace inst_upd.iminecraft with m.oidata.iminecraft in 'inst_upd'
	replace inst_upd.iloader with m.oidata.iloader in 'inst_upd'

	if empty(inst_upd.icfdata)

		replace inst_upd.icfdata with '"name": "CurseForgeModpackName"' + 0h0d0a + '"version": "CurseForgeModpackVersion"' + 0h0d0a + '"author": "CurseForgeAuthorName"' in 'inst_upd'

	endif

endif

use in 'inst_upd'
use in 'blist_upd'
use in 'log_upd'

_restorearea(m.nselect)

_logwrite('INSTANCE UPDATE END')


 