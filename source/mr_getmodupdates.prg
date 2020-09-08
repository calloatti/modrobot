*!* mr_getmodupdates

lparameters piguid, prguid

local nselect

m.nselect = select()

if not used('mods_gmu')

	use 'mr_mods' in 0 again alias 'mods_gmu'

endif

_logwrite('GET MOD UPDATES START')

select 'mods_gmu'

if empty(m.prguid)

	scan for mods_gmu.iguid == m.piguid and mods_gmu.aid > 0

		mr_getmodupdates_record()

	endscan

else

	scan for mods_gmu.rguid == m.prguid and mods_gmu.aid > 0

		mr_getmodupdates_record()

	endscan

endif

_logwrite('GET MOD UPDATES END')

use in 'mods_gmu'

_restorearea(m.nselect)

procedure mr_getmodupdates_record

local loader1

_logwrite('GET MOD UPDATE', mods_gmu.fid1)

m.loader1 = mods_gmu.loader1

if empty(m.loader1)

	m.loader1 = 'FABRIC'

endif

select top 1 * from mr_fileversions ;
	where mr_fileversions.gverlong >= mr_instances.gverlong1 ;
	and mr_fileversions.gverlong <= mr_instances.gverlong2 ;
	and mr_fileversions.aid = mods_gmu.aid ;
	and mr_fileversions.loader == m.loader1 ;
	and mr_fileversions.fid >= mods_gmu.fid1 ;
	order by mr_fileversions.gverlong desc, mr_fileversions.fid desc ;
	into cursor 'sqlresult'

if reccount('sqlresult') = 0

	select top 1 * from mr_fileversions ;
		where mr_fileversions.gverlong >= mr_instances.gverlong1 ;
		and mr_fileversions.gverlong <= mr_instances.gverlong2 ;
		and mr_fileversions.aid = mods_gmu.aid ;
		and mr_fileversions.fid >= mods_gmu.fid1 ;
		order by mr_fileversions.gverlong desc, mr_fileversions.fid desc ;
		into cursor 'sqlresult'

endif

if reccount('sqlresult') = 1 then

	= seek(sqlresult.fid, 'mr_files', 'fid')

	replace mods_gmu.fid2 with mr_files.fid in 'mods_gmu'
	replace mods_gmu.filedate2 with mr_files.filedate in 'mods_gmu'
	replace mods_gmu.filelen2 with mr_files.filelen in 'mods_gmu'
	replace mods_gmu.filename2 with mr_files.filename in 'mods_gmu'
	replace mods_gmu.hash2 with mr_files.hash in 'mods_gmu'
	replace mods_gmu.rtypename2 with mr_files.rtypename in 'mods_gmu'
	replace mods_gmu.gver2 with sqlresult.gver in 'mods_gmu'
	replace mods_gmu.loader2 with mr_files.foldername in 'mods_gmu'

	if mods_gmu.fid1 # mods_gmu.fid2

		replace mods_gmu.hasupd with .t. in 'mods_gmu'

	else

		replace mods_gmu.hasupd with .f. in 'mods_gmu'

	endif

endif

use in 'sqlresult'

use in 'mr_fileversions'

endproc