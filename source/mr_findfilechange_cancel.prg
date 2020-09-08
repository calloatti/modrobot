*!* mr_findfilechange_cancel

lparameters piguid

local ffch, nselect

return

if empty(m.piguid)

	return

endif

m.nselect = select()

if not used('inst_ffcc')

	use 'mr_instances' in 0 again shared alias 'inst_ffcc'

endif

select 'inst_ffcc'

if seek(m.piguid, 'inst_ffcc', 'iguid') = .t.

	if inst_ffcc.ffcl > 0

		replace inst_ffcc.ffcl with inst_ffcc.ffcl - 1 in 'inst_ffcc'

	endif

	if inst_ffcc.ffcl = 0 and inst_ffcc.ffch > 0

		m.ffch = inst_ffcc.ffch

		CancelFileChangeEx(m.ffch)

		replace inst_ffcc.ffch with 0 in 'inst_ffcc'

	endif

endif

use in 'inst_ffcc'

_restorearea(m.nselect)





