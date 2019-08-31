*!* mr_dependencyupdate

lparameters podependency

local aid, aname, did, dname, dtype, fid, filename, nselect

m.nselect = select()

if not used('mr_enumdep_up')

	use 'mr_enum_dependencies' in 0 again shared alias 'mr_enumdep_up'

endif

if not used('mr_dep_up')

	use 'mr_dependencies' in 0 again shared alias 'mr_dep_up'

endif

if not used('mr_files_up')

	use 'mr_files' in 0 again shared alias 'mr_files_up'

endif

if not used('mr_addons_up')

	use 'mr_addons' in 0 again shared alias 'mr_addons_up'

endif

m.did	= m.podependency.id
m.aid	= m.podependency.addonid
m.fid	= m.podependency.fileid
m.dtype	= m.podependency.type

if seek(m.aid, 'mr_addons_up', 'aid') = .f.

	*!* ADD DEPENDENCY ADDON ID TO ADDONS TABLE

	mr_addonupdate(m.aid)

endif

= seek(m.aid, 'mr_addons_up', 'aid')
= seek(m.dtype, 'mr_enumdep_up', 'eid')
= seek(m.fid, 'mr_files_up', 'fid')

m.dname	   = mr_enumdep_up.ename
m.aname	   = mr_addons_up.aname
m.filename = mr_files_up.filename

if seek(m.did, 'mr_dep_up', 'did') = .f.

	append blank in 'mr_dep_up'

	replace mr_dep_up.did with m.did in 'mr_dep_up'

endif

replace ;
		mr_dep_up.aid	   with	m.aid, ;
		mr_dep_up.fid	   with	m.fid, ;
		mr_dep_up.dtype	   with	m.dtype, ;
		mr_dep_up.dname	   with	m.dname, ;
		mr_dep_up.aname	   with	m.aname, ;
		mr_dep_up.filename with	m.filename in 'mr_dep_up'

use in 'mr_enumdep_up'

use in 'mr_dep_up'

use in 'mr_files_up'

use in 'mr_addons_up'

_restorearea(m.nselect)