*!* mr_appendblank

lparameters pcursor

local orecord, setdeleted

m.nselect = select()

_restorearea(m.pcursor)

m.setdeleted = set("Deleted")

set deleted off

locate for deleted(m.pcursor) = .t.

if found(m.pcursor)

	recall in m.pcursor

	scatter memo blank name m.orecord

	gather name m.orecord

else

	append blank in m.pcursor

endif

if m.setdeleted = 'ON'

	set deleted on

endif

_restorearea(m.nselect)