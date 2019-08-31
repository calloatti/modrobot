*!* mr_getprojectstatusname

lparameters peid

m.nselect = select()

if not used('pstatus_get')

	use 'mr_enum_projectstatus' again alias 'pstatus_get' in 0

endif

=seek(m.peid, 'pstatus_get', 'eid')

m.ename = pstatus_get.ename

use in 'pstatus_get'

_restorearea(m.nselect)

return m.ename