*!* mr_fileparse_scan

local gver, gveritem, lnz, ojson

use mr_files

scan

	m.ojson = nfjsonread(_zlibuncompress(mr_files.hfjson))

	m.gver = ''

	asort(m.ojson.gameversion)

	for m.lnz = 1 to alen(m.ojson.gameversion)

		if vartype(m.ojson.gameversion[m.lnz]) = 'C'

			m.gver = m.gver + m.ojson.gameversion[m.lnz] + '|'

		endif

	endfor

	m.gver = rtrim(m.gver, 1, '|')

	replace mr_files.gver with m.gver in 'mr_files'

endscan


