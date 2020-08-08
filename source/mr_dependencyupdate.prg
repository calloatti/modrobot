*!* mr_dependencyupdate

lparameters podependency

local aid, aname, did, dname, dtype, fid, filename, nselect

m.nselect = select()

if not used('dup_enum_dependencies')

	use 'mr_enum_dependencies' in 0 again shared alias 'dup_enum_dependencies'

endif

if not used('dup_dependencies')

	use 'mr_dependencies' in 0 again shared alias 'dup_dependencies'

endif

if not used('dup_files')

	use 'mr_files' in 0 again shared alias 'dup_files'

endif

if not used('dup_addons')

	use 'mr_addons' in 0 again shared alias 'dup_addons'

endif

m.did	= m.podependency.id
m.aid	= m.podependency.addonid
m.fid	= m.podependency.fileid
m.dtype	= m.podependency.type

if seek(m.aid, 'dup_addons', 'aid') = .f.

	*!* ADD DEPENDENCY ADDON ID TO ADDONS TABLE

	mr_addonupdate(m.aid)

endif

= seek(m.aid, 'dup_addons', 'aid')
= seek(m.dtype, 'dup_enum_dependencies', 'eid')
= seek(m.fid, 'dup_files', 'fid')

m.dname	   = dup_enum_dependencies.ename
m.aname	   = dup_addons.aname
m.filename = dup_files.filename

if seek(m.did, 'dup_dependencies', 'did') = .f.

	append blank in 'dup_dependencies'

	replace dup_dependencies.did with m.did in 'dup_dependencies'

endif

replace ;
	dup_dependencies.aid	  with m.aid, ;
	dup_dependencies.fid	  with m.fid, ;
	dup_dependencies.dtype	  with m.dtype, ;
	dup_dependencies.dname	  with m.dname, ;
	dup_dependencies.aname	  with m.aname, ;
	dup_dependencies.filename with m.filename in 'dup_dependencies'

use in 'dup_enum_dependencies'

use in 'dup_dependencies'

use in 'dup_files'

use in 'dup_addons'

_restorearea(m.nselect)