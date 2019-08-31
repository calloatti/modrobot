*!* mr_genmodlist_download

lparameters piguid

local lf, nselect, txt, url, url1, url2

m.nselect = select()

if not used('instances_gml')

	use 'mr_instances' again alias 'instances_gml' in 0

endif

if not used('mods_gml')

	use 'mr_mods' again alias 'mods_gml' in 0

	set order to tag 'filename1'

endif

if not used('files_gml')

	use 'mr_files' again alias 'files_gml' in 0

endif

= seek(m.piguid, 'instances_gml', 'iguid')

m.lf = 0h0d0a

m.txt = 'set curlparams=--proxy "127.0.0.1:8888" --fail --insecure --progress-bar --location --user-agent "CurseClient/7.5 (Microsoft Windows NT 6.2.9200.0) CurseClient/7.5.7123.41619" --header "Connection: Keep-Alive"' + m.lf + m.lf

m.txt = 'set curlparams=--fail --insecure --progress-bar --location' + m.lf + m.lf

select 'mods_gml'

scan for mods_gml.iguid = m.piguid and mods_gml.fid1 > 0 && And Not Justext(mods_gml.filename1) = 'disabled'

	if seek(mods_gml.fid1, 'files_gml', 'fid') = .f. then

		loop

	endif

	m.url = mr_geturlfile1(files_gml.fid, files_gml.filename)

	m.url = strtran(m.url, '%', '%%')

	m.txt = m.txt + 'if not exist "%~dp0' + mods_gml.fid1 + '" curl %curlparams% -o "%~dp0' + mods_gml.fid1 + '" ^"' + m.url + '"' + m.lf

endscan

m.txt = m.txt + 'pause' + m.lf

strtofile(m.txt, addbs(instances_gml.ifolder) + '_gmlnload_mods.cmd')

messagebox('INSTANCE DOWNLOAD LIST SAVED TO ' + addbs(instances_gml.ifolder) + '_gmlnload_mods.cmd' + ' AND COPIED TO CLIPBOARD', 64, 'MODROBOT')

use in 'files_gml'

use in 'mods_gml'

use in 'instances_gml'

_restorearea(m.nselect)






