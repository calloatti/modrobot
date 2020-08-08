*!* mr_fileparse

lparameters paid, pfjson, paname, pslug, pauthorname

Local fid, foldername, guid, gver, gveritem, gverlong, hfjson, lnx, lnz, nselect, ofjson, ojson
Local slug

if empty(m.pfjson) or m.pfjson == '[]' then

	return

endif

m.nselect = select()

if not used('fpa_fileversions')

	use 'mr_fileversions' again alias 'fpa_fileversions' in 0

endif

if not used('fpa_enum_gameversion')

	use 'mr_enum_gameversion' again alias 'fpa_enum_gameversion' in 0

endif

if not used('fpa_enum_filereleasetype')

	use 'mr_enum_filereleasetype' again alias 'fpa_enum_filereleasetype' in 0

endif

if not used('fpa_files')

	use 'mr_files' again alias 'fpa_files' in 0

endif

m.slug = m.pslug

*!* SPLIT EACH ELEMENT OF THE FILES JSON TO GET ONE JSON PER FILE

m.ofjson = nfjsonsplitmem(m.pfjson)

for m.lnx = 1 to m.ofjson.count

	*!* GET ONE JSON ITEM

	m.hfjson = m.ofjson.item[m.lnx]

	*!* PARSE JSON

	m.ojson = nfjsonread(m.hfjson)

	*!* ZIP JSON

	m.hfjson = _zlibcompress(m.hfjson)

	m.fid = m.ojson.id

	_logwrite('FILE PARSE', m.fid)

	if seek(m.fid, 'fpa_files', 'FID') = .f. then

		append blank in 'fpa_files'

		replace fpa_files.fid with m.fid in 'fpa_files'

	endif

	replace ;
		fpa_files.authorname with m.pauthorname, ;
		fpa_files.aid		 with m.paid, ;
		fpa_files.aname		 with m.paname, ;
		fpa_files.slug		 with m.slug in 'fpa_files'

	if fpa_files.hfjson == m.hfjson

		loop

	endif

	replace fpa_files.hfjson with m.hfjson in 'fpa_files'

	replace ;
		fpa_files.dispname with	m.ojson.displayname, ;
		fpa_files.filedate with	m.ojson.filedate, ;
		fpa_files.fileext  with	justext(m.ojson.filename), ;
		fpa_files.filelen  with	m.ojson.filelength, ;
		fpa_files.filename with	m.ojson.filename, ;
		fpa_files.hash	   with	m.ojson.packagefingerprint, ;
		fpa_files.rtype	   with	m.ojson.releasetype in 'fpa_files'

	*!* RELEASE TYPE

	if seek(fpa_files.rtype, 'fpa_enum_filereleasetype', 'eid') = .t.

		replace fpa_files.rtypename with fpa_enum_filereleasetype.ename in 'fpa_files'

	endif

	*!* FIND mcmod.info/fabric.mod.json/riftmod.json MODULES

	if vartype(m.ojson.modules) = 'O'

		for m.lnz = 1 to alen(m.ojson.modules)

			m.foldername = lower(m.ojson.modules[m.lnz].foldername )

			do case

			case 'mcmod.info' $ m.foldername

				replace fpa_files.foldername with 'FORGE' in 'fpa_files'

				*!* NO EXIT HERE SINCE THE JAR CAN ALSO HAVE A fabric.mod.json INSIDE	            

			case 'fabric.mod.json' $ m.foldername

				replace fpa_files.foldername with 'FABRIC' in 'fpa_files'

				exit

			case 'riftmod.json' $ m.foldername

				replace fpa_files.foldername with 'RIFT' in 'fpa_files'

				exit

			case 'litemod.json' $ m.foldername

				replace fpa_files.foldername with 'LITELOADER' in 'fpa_files'

				exit

			endcase

		endfor

	endif

	*!* UPDATE MR_ENUM_GAMEVERSION

	m.gver = ''

	asort(m.ojson.gameversion)

	for m.lnz = 1 to alen(m.ojson.gameversion)

		if vartype(m.ojson.gameversion[m.lnz]) = 'C'

			m.gveritem = m.ojson.gameversion[m.lnz]

			m.gver = m.gver + m.gveritem + '|'

			if left(m.gveritem, 2) = '1.'

				m.gverlong = mr_getgameversionlong(m.gveritem)

				*!* ADD TO VERSIONS TABLE

				if seek(m.gveritem, 'fpa_enum_gameversion', 'gver') = .f.

					append blank in 'fpa_enum_gameversion'

					replace	fpa_enum_gameversion.gver with m.gveritem, fpa_enum_gameversion.gverlong with m.gverlong in 'fpa_enum_gameversion'

				endif

				*!* ADD TO FILEVERSIONS TABLE

				m.guid = _md5hashstring(m.gverlong + transform(m.fid))

				if seek(m.guid, 'fpa_fileversions', 'guid') = .f.

					append blank in 'fpa_fileversions'

				endif

				replace ;
					fpa_fileversions.guid	  with m.guid, ;
					fpa_fileversions.aid	  with fpa_files.aid, ;
					fpa_fileversions.fid	  with fpa_files.fid, ;
					fpa_fileversions.filedate with fpa_files.filedate, ;
					fpa_fileversions.filename with fpa_files.filename, ;
					fpa_fileversions.gver	  with m.gveritem, ;
					fpa_fileversions.gverlong with m.gverlong, ;
					fpa_fileversions.loader	  with fpa_files.foldername, ;
					fpa_fileversions.hash	  with fpa_files.hash in 'fpa_fileversions'

			endif

		endif

	endfor

	*!* UPDATE THE MC VERSION LIST

	m.gver = rtrim(m.gver, 1, '|')

	replace fpa_files.gver with m.gver in 'fpa_files'

endfor

use in 'fpa_fileversions'

use in 'fpa_enum_gameversion'

use in 'fpa_enum_filereleasetype'

use in 'fpa_files'

_restorearea(m.nselect) 