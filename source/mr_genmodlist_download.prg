*!* mr_genmodlist_download

Lparameters piguid

Local lf, nselect, txt, url

m.nselect = Select()

If Not Used('instances_gml')

   Use 'mr_instances' Again Alias 'instances_gml' In 0

Endif

If Not Used('mods_gml')

   Use 'mr_mods' Again Alias 'mods_dow' In 0

   Set Order To Tag 'filename1'

Endif

= Seek(m.piguid, 'instances_gml', 'iguid')

m.lf = 0h0d0a

m.txt = ''

m.reqheader = '"User-Agent: CurseClient/7.5 (Microsoft Windows NT 6.2.9200.0) CurseClient/7.5.7076.33481"'

Select 'mods_dow'

Scan For mods_dow.iguid = m.piguid And mods_dow.aid > 0 And Not Justext(mods_dow.filename1) = 'disabled'

   m.url = mr_geturlfile1(mods_dow.fid1, mods_dow.filename1)

   m.txt = m.txt + 'curl --header ' + m.reqheader + ' --progress-bar -o "%~dp0' + mods_dow.filename1 + '" ' + m.url + m.lf

   m.txt = m.txt + 'timeout 15 /nobreak' + m.lf

Endscan

m.txt = m.txt + 'pause' + m.lf

_Cliptext = m.txt

Strtofile(m.txt, Addbs(instances_gml.ifolder) + '_download_mods.cmd')

Messagebox('INSTANCE DOWNLOAD LIST SAVED TO ' + Addbs(instances_gml.ifolder) + '_download_mods.cmd' + ' AND COPIED TO CLIPBOARD', 64, 'MODROBOT')

Use In 'mods_dow'

Use In 'instances_gml'

_restorearea(m.nselect)
