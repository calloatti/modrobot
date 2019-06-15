*!* mr_dependencyupdate

Lparameters podependency

Local aid, aname, did, dname, dtype, fid, filename, nselect

m.nselect = Select()

If Not Used('mr_enumdep_up')

   Use 'mr_enum_dependencies' In 0 Again Shared Alias 'mr_enumdep_up'

Endif

If Not Used('mr_dep_up')

   Use 'mr_dependencies' In 0 Again Shared Alias 'mr_dep_up'

Endif

If Not Used('mr_files_up')

   Use 'mr_files' In 0 Again Shared Alias 'mr_files_up'

Endif

If Not Used('mr_addons_up')

   Use 'mr_addons' In 0 Again Shared Alias 'mr_addons_up'

Endif

m.did	= m.podependency.Id
m.aid	= m.podependency.addonid
m.fid	= m.podependency.fileid
m.dtype	= m.podependency.Type


If Seek(m.aid, 'mr_addons_up', 'aid') = .F.

   *!* ADD DEPENDENCY ADDON ID TO ADDONS TABLE

   mr_addonupdate(m.aid)

Endif

= Seek(m.aid, 'mr_addons_up', 'aid')
= Seek(m.dtype, 'mr_enumdep_up', 'eid')
= Seek(m.fid, 'mr_files_up', 'fid')

m.dname	   = mr_enumdep_up.ename
m.aname	   = mr_addons_up.aname
m.filename = mr_files_up.filename

If Seek(m.did, 'mr_dep_up', 'did') = .F.

   Append Blank In 'mr_dep_up'

   Replace mr_dep_up.did With m.did In 'mr_dep_up'

Endif

Replace mr_dep_up.aid With m.aid In 'mr_dep_up'
Replace mr_dep_up.fid With m.fid In 'mr_dep_up'
Replace mr_dep_up.dtype With m.dtype In 'mr_dep_up'
Replace mr_dep_up.dname With m.dname In 'mr_dep_up'
Replace mr_dep_up.aname With m.aname In 'mr_dep_up'
Replace mr_dep_up.filename With m.filename In 'mr_dep_up'

_restorearea(m.nselect)