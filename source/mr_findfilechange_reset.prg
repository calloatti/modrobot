*!* mr_findfilechange_reset

lparameters piguid

local hffc, nselect

return

m.nselect = select()

if not used('inst_ffcr')

	use 'mr_instances' in 0 again shared alias 'inst_ffcr'

endif

select 'inst_ffcr'

scan

	replace inst_ffcr.ffch with 0 in 'inst_ffcr'
	replace inst_ffcr.ffcl with 0 in 'inst_ffcr'
	replace inst_ffcr.ffci with 0 in 'inst_ffcr'

endscan

use in 'inst_ffcr'

_restorearea(m.nselect)





