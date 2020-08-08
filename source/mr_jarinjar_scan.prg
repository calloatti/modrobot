*!* mr_jarinjar_scan

lparameters piguid, pfolder

local afiles[1], filename, filespec, fileunc, lnx, ncount, nselect

m.nselect = select()

if not used('scn_jijs')

	use 'mr_jijs' in 0 again shared alias 'scn_jijs'

endif

select 'scn_jijs'

_logwrite('SCAN START')

delete for scn_jijs.iguid == m.piguid in 'scn_jijs'

*!* SCAN FOLDER FOR FILES

m.filespec = addbs(m.pfolder) + '*.*'

m.ncount = adir(afiles, m.filespec, '', 1)

for m.lnx = 1 to m.ncount

	m.filename	= m.afiles(m.lnx, 1)

	if not inlist(upper(justext(m.filename)), 'JAR', 'DISABLED')

		loop

	endif

	m.fileunc = addbs(m.pfolder) + m.filename

	_logwrite(m.fileunc)

	mr_jarinjar_filescan(m.piguid, m.filename, filetostr(m.fileunc), 0)

endfor

_logwrite('SCAN END')

use in 'scn_jijs'

_restorearea(m.nselect)

return

procedure mr_jarinjar_filescan

lparameters piguid, pfilename, pfiledata, plevel

local filedata, jijsize, lnx, omodprops

m.omodprops = mr_getmodproperties('', m.pfiledata)

m.jijsize = len(m.pfiledata)

mr_appendblank('scn_jijs')

replace scn_jijs.iguid with	m.piguid, ;
	scn_jijs.filename  with	m.pfilename, ;
	scn_jijs.jij	   with	justfname(m.pfilename), ;
	scn_jijs.jijlevel  with	m.plevel in 'scn_jijs'

if not empty(m.omodprops.mod_requires)

	replace scn_jijs.requires with 1 in 'scn_jijs'

endif

replace scn_jijs.jenv with m.omodprops.mod_environment, ;
	scn_jijs.modid	  with m.omodprops.mod_id, ;
	scn_jijs.jmod	  with m.omodprops.jsonfabric, ;
	scn_jijs.jijsize  with m.jijsize, ;
	scn_jijs.dfabric  with m.omodprops.depends.fabric, ;
	scn_jijs.dfloader with m.omodprops.depends.fabricloader, ;
	scn_jijs.dmc	  with m.omodprops.depends.minecraft in 'scn_jijs'

if type('m.omodprops.mod_jars[1].file') = 'C'

	for m.lnx = 1 to alen(m.omodprops.mod_jars)

		m.filedata =  mr_getfilefromzipdata(m.pfiledata, m.omodprops.mod_jars[m.lnx].file)

		mr_jarinjar_filescan(m.piguid, m.pfilename + '/' + justfname(m.omodprops.mod_jars[m.lnx].file), m.filedata, m.plevel + 1)

	endfor

endif

endproc



