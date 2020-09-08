*!* mr_findfilechange_init

#define FILE_NOTIFY_CHANGE_FILE_NAME    0x00000001
#define FILE_NOTIFY_CHANGE_DIR_NAME     0x00000002
#define FILE_NOTIFY_CHANGE_ATTRIBUTES   0x00000004
#define FILE_NOTIFY_CHANGE_SIZE         0x00000008
#define FILE_NOTIFY_CHANGE_LAST_WRITE   0x00000010
#define FILE_NOTIFY_CHANGE_SECURITY     0x00000100

lparameters piguid

Local bwatchsubtree, cfolder, ffch, nfilter, nselect

return

if empty(m.piguid)

	return

endif

m.nselect = select()

if not used('inst_ffci')

	use 'mr_instances' in 0 again shared alias 'inst_ffci'

endif

select 'inst_ffci'

if seek(m.piguid, 'inst_ffci', 'iguid') = .t.

	vfp2c32()

	m.cfolder		= alltrim(inst_ffci.ifolder)
	m.bwatchsubtree	= .t.
	m.nfilter		= FILE_NOTIFY_CHANGE_FILE_NAME

	if directory(m.cfolder)

		*!* IF THE WATCH LEVEL IS 0 THEN SET IT UP

		if inst_ffci.ffcl = 0

			m.ffch = FindFileChangeEx(m.cfolder, m.bwatchsubtree, m.nfilter, 'mr_findfilechange_notification')

			replace inst_ffci.ffch with m.ffch in 'inst_ffci'

		endif

		replace inst_ffci.ffcl with inst_ffci.ffcl + 1 in 'inst_ffci'

	endif

endif

use in 'inst_ffci'

_restorearea(m.nselect)









 