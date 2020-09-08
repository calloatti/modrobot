*!* mr_blacklist_clean


lparameters piguid, pifolder

Local blmd5, blpath, instancefolder, nselect, orecord


m.nselect = select()

if not used('sca_blacklist')

	use 'mr_blacklist' again alias 'sca_blacklist' in 0

endif

if not used('seek_blacklist')

	use 'mr_blacklist' again alias 'seek_blacklist' in 0

endif

_logwrite('CLEAN START')

m.instancefolder = mr_getinstancefolderfrommodsfolder(m.pifolder)

select 'sca_blacklist'

scan

	if not sca_blacklist.iguid == mr_instances.iguid

		loop

	endif

	_logwrite(sca_blacklist.blpath)

	if sca_blacklist.blblack = .f.

		replace sca_blacklist.iguid with '00000000' in 'sca_blacklist'

		loop

	endif

	m.blpath = justpath(sca_blacklist.blpath)

	do while not m.blpath == justpath(m.blpath)

		m.blmd5 = _md5hashstring(lower(m.blpath))

		if seek(m.blmd5, 'seek_blacklist', 'blmd5') = .t. and seek_blacklist.blblack = .t.

			scatter memo blank name m.orecord

			m.orecord.iguid = '00000000'

			gather name m.orecord

		endif

		m.blpath = justpath(m.blpath)

	enddo

endscan

delete for sca_blacklist.iguid == '00000000' in 'sca_blacklist'

_logwrite('CLEAN END')

use in 'sca_blacklist'

use in 'seek_blacklist'

_restorearea(m.nselect)