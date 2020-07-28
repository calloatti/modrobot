*!* mr_blacklist_scan

lparameters piguid, pifolder

Local blmd5, blmd5tocheck, blpath, blpathtocheck, doadditem, instancefolder, nselect

m.nselect = select()

if not used('black_bls')

	use 'mr_blacklist' again alias 'black_bls' in 0

endif

_logwrite('SCAN START')

m.instancefolder = mr_getinstancefolderfrommodsfolder(m.pifolder)

_logwrite('SCAN FOLDERS START', m.instancefolder)

_findfilesinfoldertree(m.instancefolder, '*.*')

_logwrite('SCAN FOLDERS END')

select 'foundfiles'

scan

	m.blpath = foundfiles.filename

	m.blmd5 = _md5hashstring(lower(m.blpath))

	if seek(m.blmd5, 'black_bls', 'blmd5') = .t.

		loop

	endif

	*!* CHECK IF SOME PARENT FOLDER IS NOT BLACKLISTED

	m.doadditem = .t.

	m.blpathtocheck = justpath(m.blpath)

	do while not lower(m.blpathtocheck) == lower(m.instancefolder)

		m.blmd5tocheck = _md5hashstring(lower(m.blpathtocheck))

		if seek(m.blmd5tocheck, 'black_bls', 'blmd5') = .t. and black_bls.blblack = .t.

			m.doadditem = .f.

			exit

		endif

		m.blpathtocheck = justpath(m.blpathtocheck)

	enddo

	if m.doadditem = .f.

		*loop

	endif

	*!* ADD ITEM

	_logwrite(m.blpath)

	if seek('00000000', 'black_bls', 'iguid') = .f.

		append blank in 'black_bls'

	endif

	replace black_bls.blpath with m.blpath in 'black_bls'
	replace black_bls.isfolder with foundfiles.filefolder in 'black_bls'
	replace black_bls.blmd5 with m.blmd5 in 'black_bls'
	replace black_bls.iguid with m.piguid in 'black_bls'

	* ! * ADD FOLDERS OF ITEM

	m.blpath = justpath(m.blpath)

	do while not lower(m.blpath) == lower(m.instancefolder)

		m.blmd5 = _md5hashstring(lower(m.blpath))

		if seek(m.blmd5, 'black_bls', 'blmd5') = .f.

			_logwrite(m.blpath)

			append blank in 'black_bls'

			replace black_bls.blpath with m.blpath in 'black_bls'
			replace black_bls.isfolder with foundfiles.filefolder in 'black_bls'
			replace black_bls.blmd5 with m.blmd5 in 'black_bls'
			replace black_bls.iguid with m.piguid in 'black_bls'

		endif

		m.blpath = justpath(m.blpath)

	enddo

endscan

use in 'foundfiles'

_logwrite('SCAN END')

use in 'black_bls'

_restorearea(m.nselect)















 