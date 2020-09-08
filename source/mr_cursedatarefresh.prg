*!* mr_cursedatarefresh

lparameters piguid, prguid

Local nselect

m.nselect = select()

if not used('files_cdr')

	use 'mr_files' in 0 again shared alias 'files_cdr'

endif

if not used('mods_cdr')

	use 'mr_mods' in 0 again alias 'mods_cdr'

endif

_logwrite('CURSE DATA REFRESH START')

select 'mods_cdr'

if empty(m.prguid)

	scan for mods_cdr.iguid == m.piguid

		if seek(mods_cdr.hash1, 'files_cdr', 'hash') = .t.

			mr_cursedatarefresh_update()

		endif

	endscan

else

	scan for mods_cdr.rguid == m.prguid

		if seek(mods_cdr.hash1, 'files_cdr', 'hash') = .t.

			mr_cursedatarefresh_update()

		endif

	endscan

endif

_logwrite('CURSE DATA REFRESH END')

use in 'files_cdr'

use in 'mods_cdr'

_restorearea(m.nselect)

procedure mr_cursedatarefresh_update

_logwrite('CURSE DATA REFRESH', files_cdr.fid)

replace ;
	mods_cdr.aid		with files_cdr.aid, ;
	mods_cdr.aname		with files_cdr.aname, ;
	mods_cdr.authorname	with files_cdr.authorname, ;
	mods_cdr.fid1		with files_cdr.fid, ;
	mods_cdr.filedate1	with files_cdr.filedate, ;
	mods_cdr.gver1		with files_cdr.gver, ;
	mods_cdr.rtypename1	with files_cdr.rtypename, ;
	mods_cdr.loader1	with files_cdr.foldername in 'mods_cdr'

replace ;
	mods_cdr.fid2		with files_cdr.fid, ;
	mods_cdr.filedate2	with files_cdr.filedate, ;
	mods_cdr.gver2		with files_cdr.gver, ;
	mods_cdr.rtypename2	with files_cdr.rtypename, ;
	mods_cdr.loader2	with files_cdr.foldername in 'mods_cdr'

replace ;
	mods_cdr.filelen2  with	mods_cdr.filelen1, ;
	mods_cdr.filename2 with	mods_cdr.filename1, ;
	mods_cdr.hash2	   with	mods_cdr.hash1 in 'mods_cdr'

endproc





  