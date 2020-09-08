*!* mr_cursedataget

lparameters piguid, prguid

Local winhttp as 'winhttp' of 'winhttp.vcx'
Local aid, aname, authorname, fjson, lnx, lnz, nselect, ofile, ojson, body, slug, url

m.nselect = select()

if not used('addons_cdg')

	use 'mr_addons' in 0 again alias 'addons_cdg'

endif

if not used('mods_cdg')

	use 'mr_mods' in 0 again alias 'mods_cdg'

endif

select 'mods_cdg'

_logwrite('FINGERPRINT START')

m.body = '['

if empty(m.prguid)

	scan for mods_cdg.iguid == m.piguid

		m.body = m.body + transform(mods_cdg.hash1) + ','

	endscan

else

	scan for mods_cdg.rguid == m.prguid

		m.body = m.body + transform(mods_cdg.hash1) + ','

	endscan

endif

m.body = rtrim(m.body, 1, ',') + ']'

m.winhttp = newobject('winhttp', 'winhttp.vcx')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

*!* m.winhttp.setproxy(2, 'localhost:8888')

m.winhttp.option_enableredirects = .t.

m.winhttp.gzip = .t.

m.url = mr_geturlapi_fingerprint()

m.winhttp.open('POST', m.url, .t.)

m.winhttp.setrequestheader('Accept', 'application/json')

m.winhttp.setrequestheader('Content-Type', 'application/json')

m.winhttp.send(m.body)

do while m.winhttp.waitforresponse(0) = 0

	doevents

	_apisleep(50)

enddo

mr_winhttplog(m.winhttp)

_logwrite('FINGERPRINT RESPONSE:', m.winhttp.responsestatus)

if m.winhttp.responsestatus = 200 then

	m.ojson = nfjsonread(m.winhttp.getresponse())

	if vartype(m.ojson.exactmatches[1]) = 'O'

		for m.lnx = 1 to alen(m.ojson.exactmatches)

			m.aid = m.ojson.exactmatches[m.lnx].id

			*!* UPDATE ADDON

			mr_addonupdate(m.aid)

			*!* PROCESS EACH FILE AND ADD IT TO FILES TABLE IN CASE IT IS AN ADDITIONAL FILE
			*!* AND IT WILL NOT BE INCLUDED IN THE FILES API CALL

			m.fjson = nfjsoncreate(m.ojson.exactmatches(m.lnx).file)

			*!* GET MISSING DATA FROM ADDONS TABLE (ADDON MAY NOT BE FOUND IN TABLE)

			= seek(m.aid, 'addons_cdg', 'aid')

			m.aname = addons_cdg.aname

			m.slug = addons_cdg.slug

			m.authorname = addons_cdg.authorname

			_logwrite('PARSE FINGERPRINT', m.ojson.exactmatches(m.lnx).file.id)

			mr_fileparse(m.aid, m.fjson, m.aname, m.slug, m.authorname)

		endfor


		*!* ADD DEPENDENCIES

		for m.lnx = 1 to alen(m.ojson.exactmatches)

			m.ofile = m.ojson.exactmatches[m.lnx].file

			if vartype(m.ofile.dependencies[1]) = 'O'

				for m.lnz = 1 to alen(m.ofile.dependencies)

					mr_dependencyupdate(m.ofile.dependencies[m.lnz])

				endfor

			endif

		endfor

	endif

endif

_logwrite('FINGERPRINT END', m.winhttp.responsestatus)

use in 'mods_cdg'

use in 'addons_cdg'

_restorearea(m.nselect) 