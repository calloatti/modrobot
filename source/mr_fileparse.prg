*!* mr_fileparse

lparameters paid, pfjson, paname, pslug, pauthorname

Local fid, foldername, guid, gver, gver_files, gverlong, hfjson, lnx, lnz, nselect, ofjson, ojson
Local slug

if empty(m.pfjson) or m.pfjson == '[]' then

	return

endif

m.nselect = select()

if not used('filever_pjf')

	use 'mr_fileversions' again alias 'filever_pjf' in 0

endif

if not used('gversion_pjf')

	use 'mr_enum_gameversion' again alias 'gversion_pjf' in 0

endif

if not used('reltype_pjf')

	use 'mr_enum_filereleasetype' again alias 'reltype_pjf' in 0

endif

if not used('files_pjf')

	use 'mr_files' again alias 'files_pjf' in 0

endif

m.slug = m.pslug

*!* SPLIT EACH ELEMENT OF THE FILES JSON TO GET ONE JSON PER FILE

m.ofjson = mr_filejsonsplit(m.pfjson)

for m.lnx = 1 to m.ofjson.count

	*!* GET ONE JSON ITEM
	
	m.hfjson = m.ofjson.item[m.lnx]
	
	*!* PARSE JSON
	
	m.ojson = nfjsonread(m.hfjson)
	
	*!* ZIP JSON
	
	m.hfjson = _zlibcompress(m.hfjson)

	m.fid = m.ojson.id

	_logwrite('FILE PARSE', m.fid)

	if seek(m.fid, 'files_pjf', 'FID') = .f. then

		append blank in 'files_pjf'

		replace files_pjf.fid with m.fid in 'files_pjf'

	endif

	if files_pjf.hfjson == m.hfjson

		loop

	endif

	replace files_pjf.hfjson with m.hfjson in 'files_pjf'

	replace ;
			files_pjf.authorname with m.pauthorname, ;
			files_pjf.aid		 with m.paid, ;
			files_pjf.aname		 with m.paname, ;
			files_pjf.slug		 with m.slug, ;
			files_pjf.dispname	 with m.ojson.displayname, ;
			files_pjf.filedate	 with m.ojson.filedate, ;
			files_pjf.fileext	 with justext(m.ojson.filename), ;
			files_pjf.filelen	 with m.ojson.filelength, ;
			files_pjf.filename	 with m.ojson.filename, ;
			files_pjf.hash		 with m.ojson.packagefingerprint, ;
			files_pjf.rtype		 with m.ojson.releasetype in 'files_pjf'

	*!* RELEASE TYPE

	if seek(files_pjf.rtype, 'reltype_pjf', 'eid') = .t.

		replace files_pjf.rtypename with reltype_pjf.ename in 'files_pjf'

	endif

	*!* FIND mcmod.info/fabric.mod.json/riftmod.json MODULES

	if vartype(m.ojson.modules) = 'O'

		for m.lnz = 1 to alen(m.ojson.modules)

			m.foldername = lower(m.ojson.modules[m.lnz].foldername )

			do case

			case 'mcmod.info' $ m.foldername

				replace files_pjf.foldername with 'FORGE' in 'files_pjf'

				*!* NO EXIT HERE SINCE THE JAR CAN ALSO HAVE A fabric.mod.json INSIDE	            

			case 'fabric.mod.json' $ m.foldername

				replace files_pjf.foldername with 'FABRIC' in 'files_pjf'

				exit

			case 'riftmod.json' $ m.foldername

				replace files_pjf.foldername with 'RIFT' in 'files_pjf'

				exit

			case 'litemod.json' $ m.foldername

				replace files_pjf.foldername with 'LITELOADER' in 'files_pjf'

				exit

			endcase

		endfor

	endif

	*!* UPDATE MR_ENUM_GAMEVERSION

	m.gver_files = ''

	for m.lnz = 1 to alen(m.ojson.gameversion)

		if vartype(m.ojson.gameversion[m.lnz]) = 'C'

			m.gver = m.ojson.gameversion[m.lnz]

			m.gver_files = m.gver_files + m.gver + '|'

			if left(m.gver, 2) = '1.'

				m.gverlong = mr_getgameversionlong(m.gver)

				*!* ADD TO VERSIONS TABLE

				if seek(m.gver, 'gversion_pjf', 'gver') = .f.

					append blank in 'gversion_pjf'

					replace	gversion_pjf.gver with m.gver, gversion_pjf.gverlong with m.gverlong in 'gversion_pjf'

				endif

				*!* ADD TO FILEVERSIONS TABLE

				m.guid = _md5hashstring(m.gverlong + transform(m.fid))

				if seek(m.guid, 'filever_pjf', 'guid') = .f.

					append blank in 'filever_pjf'

				endif

				replace ;
						filever_pjf.guid	 with m.guid, ;
						filever_pjf.aid		 with files_pjf.aid, ;
						filever_pjf.fid		 with files_pjf.fid, ;
						filever_pjf.filedate with files_pjf.filedate, ;
						filever_pjf.filename with files_pjf.filename, ;
						filever_pjf.gver	 with m.gver, ;
						filever_pjf.gverlong with m.gverlong, ;
						filever_pjf.loader	 with files_pjf.foldername, ;
						filever_pjf.hash	 with files_pjf.hash in 'filever_pjf'

			endif

		endif

	endfor

	*!* UPDATE THE MC VERSION LIST

	m.gver_files = rtrim(m.gver_files, 1, '|')

	replace files_pjf.gver with m.gver_files in 'files_pjf'

endfor

*!*	use in 'filever_pjf'

*!*	use in 'gversion_pjf'

*!*	use in 'reltype_pjf'

*!*	use in 'files_pjf'

_restorearea(m.nselect)  