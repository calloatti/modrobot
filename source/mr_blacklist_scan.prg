*!* mr_blacklist_scan

lparameters piguid, pifolder

Local blmd5, blmd5tocheck, blpath, blpathtocheck, doadditem, instancefolder, nselect

m.nselect = select()

if not used('sca_blacklist')

	use 'mr_blacklist' again alias 'sca_blacklist' in 0

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

	if seek(m.blmd5, 'sca_blacklist', 'blmd5') = .t.

		loop

	endif

	*!* CHECK IF SOME PARENT FOLDER IS NOT BLACKLISTED

	m.doadditem = .t.

	m.blpathtocheck = justpath(m.blpath)

	do while not lower(m.blpathtocheck) == lower(m.instancefolder)

		m.blmd5tocheck = _md5hashstring(lower(m.blpathtocheck))

		if seek(m.blmd5tocheck, 'sca_blacklist', 'blmd5') = .t. and sca_blacklist.blblack = .t.

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

	mr_appendblank('sca_blacklist')
	
	replace sca_blacklist.blpath with m.blpath in 'sca_blacklist'
	replace sca_blacklist.isfolder with foundfiles.filefolder in 'sca_blacklist'
	replace sca_blacklist.blmd5 with m.blmd5 in 'sca_blacklist'
	replace sca_blacklist.iguid with m.piguid in 'sca_blacklist'

	* ! * ADD FOLDERS OF ITEM

	m.blpath = justpath(m.blpath)

	do while not lower(m.blpath) == lower(m.instancefolder)

		m.blmd5 = _md5hashstring(lower(m.blpath))

		if seek(m.blmd5, 'sca_blacklist', 'blmd5') = .f.

			_logwrite(m.blpath)

			mr_appendblank('sca_blacklist')

			replace sca_blacklist.blpath with m.blpath in 'sca_blacklist'
			replace sca_blacklist.isfolder with foundfiles.filefolder in 'sca_blacklist'
			replace sca_blacklist.blmd5 with m.blmd5 in 'sca_blacklist'
			replace sca_blacklist.iguid with m.piguid in 'sca_blacklist'

		endif

		m.blpath = justpath(m.blpath)

	enddo

endscan

use in 'foundfiles'

_logwrite('SCAN END')

use in 'sca_blacklist'

_restorearea(m.nselect)















 