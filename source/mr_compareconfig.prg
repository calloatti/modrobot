*!* mr_compareconfig

local filename, folder1, folder2

select * from 'mr_comparelog' where 1 = 0 into cursor 'sql_log1' readwrite

if used('sql_log')

	use in 'sql_log'

endif

use dbf('sql_log1') again in 0 alias 'sql_log'

select 'sql_log'

index on sql_log.filename1 tag 'filename1'

index on sql_log.guid tag 'guid'

m.folder1 = "C:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.0.0\.minecraft\config"

m.folder2 = "C:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.0.1\.minecraft\config"

_findfilesinfoldertree(m.folder1)

select 'foundfiles'

scan for foundfiles.filefolder = .f.

	m.filename = ltrim(strextract(foundfiles.filename, m.folder1, '', 1, 1), 1, '\')

	append blank in 'sql_log'

	if '\' $ m.filename

		replace sql_log.guid with '1' + m.filename in 'sql_log'

	else

		replace sql_log.guid with '2' + m.filename in 'sql_log'

	endif

	replace sql_log.filename1 with m.filename in 'sql_log'

	replace sql_log.hash1 with mr_fingerprint(foundfiles.filename) in 'sql_log'

endscan


_findfilesinfoldertree(m.folder2)

select 'foundfiles'

scan for foundfiles.filefolder = .f.

	m.filename = ltrim(strextract(foundfiles.filename, m.folder2, '', 1, 1), 1, '\')

	if seek(m.filename, 'sql_log', 'filename1') = .f.

		append blank in 'sql_log'

		if '\' $ m.filename

			replace sql_log.guid with '1' + m.filename in 'sql_log'

		else

			replace sql_log.guid with '2' + m.filename in 'sql_log'

		endif

	endif

	replace sql_log.filename2 with m.filename in 'sql_log'

	replace sql_log.hash2 with mr_fingerprint(foundfiles.filename) in 'sql_log'

endscan

select 'sql_log'

scan

	if sql_log.hash1 = 0

		replace sql_log.levent with 'NEW'

		loop

	endif

	if sql_log.hash2 = 0

		replace sql_log.levent with 'DELETED'

		loop

	ENDIF
	
	if sql_log.hash1 # sql_log.hash2

		replace sql_log.levent with 'CHANGED'

		loop

	ENDIF
	

endscan

go top in 'sql_log'