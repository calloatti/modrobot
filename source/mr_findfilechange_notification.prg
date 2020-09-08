*!* mr_findfilechange_notification

lparameters pffch, pevent, pfile1, pfile2

local nselect

?m.pffch, m.pevent, m.pfile1, m.pfile2

return

m.nselect = select()

if not used('inst_ffcn')

	use 'mr_instances' in 0 again shared alias 'inst_ffcn'

endif

select 'inst_ffcn'

if seek(m.pffch, 'inst_ffcn', 'ffch') = .f.

	?'no'

	use in 'inst_ffcn'

	_restorearea(m.nselect)

	return

endif

if inst_ffcn.ffci = 1

	replace inst_ffcn.ffci with 0 in 'inst_ffcn'

	use in 'inst_ffcn'

	_restorearea(m.nselect)

	return

endif

do case

case m.pevent = 0

	_logwrite('Function: ' + m.pfile1 + " failed. ErrorNo. ", m.pfile2)

case m.pevent = 1

	_logwrite('File added: ' + m.pfile1)

case m.pevent = 2

	_logwrite('File removed: ' + m.pfile1)

case m.pevent = 3

	_logwrite('File modified: ' + m.pfile1)

case m.pevent = 4

	_logwrite('File renamed from: ' + m.pfile1 + ' to: ' + m.pfile2)

endcase

use in 'inst_ffcn'

_restorearea(m.nselect)







