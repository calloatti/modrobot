*!* mr_scanmodsfolder

lparameters piguid

Local afiles[1], fguid, filelen1, filename1, filespec, fileunc, hash1, ifolder, lnx, ncount, nselect
Local omod, omodprops, pfid1, pfid2, pfilename1, pfilename2, phash1, phash2, pifolder, pldesc
Local pmodid, rguid

m.nselect = select()

if not used('inst_smf')

	use 'mr_instances' in 0 again alias 'inst_smf'

endif

if seek(m.piguid, 'inst_smf', 'iguid') = .f.

	_logwrite('SCAN ERROR INSTANCE NOT FOUND', m.piguid)

	use in 'inst_smf'

	_restorearea(m.nselect)

	return

endif


if not used('mods_smf')

	use 'mr_mods' in 0 again alias 'mods_smf'

endif

select 'mods_smf'

_logwrite('SCAN START')

scatter blank name m.omod

m.omod.iguid = '00000000'
m.omod.fguid = '00000000'
m.omod.rguid = '0000000000000000'

*!* FIRST SCAN EXISTING RECORDS TO CHECK FOR MISSING FILES

scan for mods_smf.iguid == m.piguid

	m.fileunc = addbs(inst_smf.ifolder) + mods_smf.filename1

	_logwrite('CHECK', justfname(m.fileunc))

	m.hash1 = mr_fingerprint(m.fileunc)

	if mods_smf.hash1 # m.hash1 then

		m.pfid1		 = mods_smf.fid1
		m.pfid2		 = 0
		m.pfilename1 = mods_smf.filename1
		m.pfilename2 = ''
		m.phash1	 = mods_smf.hash1
		m.pifolder	 = inst_smf.ifolder
		m.pmodid	 = mods_smf.modid

		if m.hash1 = 0

			m.pldesc = 'DELETED'
			m.phash2 = 0

		else

			m.pldesc = 'HASH CHANGED'
			m.phash2 = m.hash1

		endif

		mr_logaddrecord(m.pfid1, m.pfid2, m.pfilename1, m.pfilename2, m.phash1, m.phash2, m.pifolder, m.piguid, m.pldesc, m.pmodid)

		*!* BLANK MR_MODS RECORD FOR LATER REUSE

		gather name m.omod

	endif

endscan

*!* SCAN FOLDER FOR FILES

m.ifolder = inst_smf.ifolder

m.filespec = addbs(m.ifolder) + '*.*'

m.ncount = adir(afiles, m.filespec, '', 1)

for m.lnx = 1 to m.ncount

	m.filename1	= m.afiles(m.lnx, 1)

	if not inlist(upper(justext(m.filename1)), 'JAR', 'DISABLED')

		loop

	endif

	m.fileunc = addbs(m.ifolder) + m.filename1

	_logwrite('SCAN', justfname(m.fileunc))

	m.filelen1 = m.afiles(m.lnx, 2)

	m.hash1 = mr_fingerprint(m.fileunc)

	m.fguid = strconv(_ubintoc(m.hash1), 15)

	m.rguid = m.piguid + m.fguid

	m.omodprops = mr_getmodproperties(m.fileunc)

	*!* IF THERE IS NO RECORD FOR THE FILE, REUSE BLANK RECORD OR APPEND NEW

	if seek(m.rguid, 'mods_smf', 'rguid') = .f.

		if seek('00000000', 'mods_smf', 'IGUID') = .f.

			append blank in 'mods_smf'

		endif

		replace mods_smf.rguid with m.rguid in 'mods_smf'
		replace mods_smf.upd with .t. in 'mods_smf'


		*!* NEW FILE ADD TO LOG

		m.pfid1		 = mods_smf.fid1
		m.pfid2		 = 0
		m.pfilename1 = m.filename1
		m.pfilename2 = ''
		m.phash1	 = m.hash1
		m.phash2	 = 0
		m.pifolder	 = inst_smf.ifolder
		m.pldesc	 = 'NEW'
		m.pmodid	 = m.omodprops.mod_id

		mr_logaddrecord(m.pfid1, m.pfid2, m.pfilename1, m.pfilename2, m.phash1, m.phash2, m.pifolder, m.piguid, m.pldesc, m.pmodid)

	endif

	replace mods_smf.iguid with m.piguid in 'mods_smf'
	replace mods_smf.fguid with m.fguid in 'mods_smf'
	replace mods_smf.filename1 with m.filename1 in 'mods_smf'
	replace mods_smf.filelen1 with m.filelen1 in 'mods_smf'
	replace mods_smf.hash1 with m.hash1 in 'mods_smf'
	replace mods_smf.modid with m.omodprops.mod_id in 'mods_smf'
	replace mods_smf.aname with m.omodprops.mod_name in 'mods_smf'
	replace mods_smf.authorname with m.omodprops.mod_authors in 'mods_smf'
	replace mods_smf.env with m.omodprops.mod_environment in 'mods_smf'
	replace mods_smf.guidicon with m.omodprops.mod_icon in 'mods_smf'
	replace mods_smf.loader1 with m.omodprops.mod_loader in 'mods_smf'

	if empty(mods_smf.guidicon)

		replace mods_smf.guidicon with mr_getblankavatar() in 'mods_smf'

	endif

	if upper(justext(mods_smf.filename1)) = 'JAR'

		replace mods_smf.ena with .t. in 'mods_smf'

	endif

	if upper(justext(mods_smf.filename1)) = 'DISABLED'

		replace mods_smf.ena with .f. in 'mods_smf'

	endif

endfor

_logwrite('SCAN END')

use in 'mods_smf'

use in 'inst_smf'

_restorearea(m.nselect)

 