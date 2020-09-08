*!* mr_gencfmodpackzip

lparameters piguid

Local blmd5, blpath, errormsg, filepath, firstfile, gverlong, html, instancefolder, lalines[1], lnx
Local manifest, minecraft_version, modloaders_id, nlines, nselect, skipfile, zfilepath
Local zipbasefolder, zipfilename, zipfilesuffix

m.nselect = select()

m.zipfilesuffix  = _inigetvalue('ZIPFILESUFFIX_CURSEFORGE', '_twitch') + '.zip'

if not used('inst_gcf')

	use 'mr_instances' again alias 'inst_gcf' in 0

endif

if not used('modloaders_gcf')

	use 'mr_modloaders' again alias 'modloaders_gcf' in 0

endif

if not used('mods_gcf')

	use 'mr_mods' again alias 'mods_gcf' in 0 order tag 'filename1'

endif

if not used('blacklist_gcf')

	use 'mr_blacklist' again alias 'blacklist_gcf' in 0

endif

if seek(m.piguid, 'inst_gcf', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	mr_gencfmodpackzip_cleanup(m.nselect)

	return

endif

*!* CHECK THAT MODPACK DATA HAS BEEN SET

m.errormsg = ''

if '"CurseForgeModpackName"' $ inst_gcf.icfdata

	m.errormsg = m.errormsg + 'REPLACE "CurseForgeModpackName" WITH THE MODPACK NAME' + 0h0d0a

endif

if '"CurseForgeModpackVersion"' $ inst_gcf.icfdata

	m.errormsg = m.errormsg + 'REPLACE "CurseForgeModpackVersion" WITH THE MODPACK VERSION' + 0h0d0a

endif

if '"CurseForgeAuthorName"' $ inst_gcf.icfdata

	m.errormsg = m.errormsg + 'REPLACE "CurseForgeAuthorName" WITH THE MODPACK AUTHOR NAME' + 0h0d0a

endif

if not empty(m.errormsg)

	messagebox(m.errormsg, 64, 'MODROBOT')

	mr_gencfmodpackzip_cleanup(m.nselect)

	return

endif

if empty(inst_gcf.izipfolder)

	messagebox('ERROR: INSTANCE OUTPUT ZIP FOLDER NOT SPECIFIED', 64, 'MODROBOT')

	mr_gencfmodpackzip_cleanup(m.nselect)

	return

endif

_logwrite('GENERATE CF MODPACK ZIP START')

select 'modloaders_gcf'

m.gverlong = mr_getgameversionlong(inst_gcf.iminecraft)

select * from 'modloaders_gcf' order by modloaders_gcf.mname desc top 1 where modloaders_gcf.gverlong == m.gverlong and modloaders_gcf.mlatest = .t. and modloaders_gcf.mreco = .t. into cursor 'sql_gcf'

if reccount('sql_gcf') = 0

	select * from 'modloaders_gcf' order by modloaders_gcf.mname desc top 1 where modloaders_gcf.gverlong == m.gverlong and modloaders_gcf.mlatest = .f. and modloaders_gcf.mreco = .t. into cursor 'sql_gcf'

endif

*!* IF NO FORGE LOADER VERSION FOUND, REFRESH MODLOADER DATA AND TRY AGAIN

if reccount('sql_gcf') = 0

	mr_modloaders_update()

	select * from 'modloaders_gcf' order by modloaders_gcf.mname desc top 1 where modloaders_gcf.gverlong == m.gverlong and modloaders_gcf.mlatest = .t. and modloaders_gcf.mreco = .t. into cursor 'sql_gcf'

endif

if reccount('sql_gcf') = 0

	select * from 'modloaders_gcf' order by modloaders_gcf.mname desc top 1 where modloaders_gcf.gverlong == m.gverlong and modloaders_gcf.mlatest = .f. and modloaders_gcf.mreco = .t. into cursor 'sql_gcf'

endif

*!* IF NO FORGE LOADER RECOMMENDED OR LATEST FOUND, USE LATEST VERSION

if reccount('sql_gcf') = 0

	select * from 'modloaders_gcf' order by modloaders_gcf.mname desc top 1 where modloaders_gcf.gverlong == m.gverlong and modloaders_gcf.mlatest = .f. and modloaders_gcf.mreco = .f. into cursor 'sql_gcf'

endif

*!* IF NO FORGE LOADER FOUND, GIVE UP

if reccount('sql_gcf') = 0

	_logwrite('ERROR CF MODPACK ZIP: FORGE RECOMMENDED VERSION NOT FOUND')

	mr_gencfmodpackzip_cleanup(m.nselect)

	return

endif

*!* PREPARE TEMP FOLDER

*!*	m.targetfolder = addbs(_getapppath()) + 'temp_modpack'

*!*	_deletefolder(m.targetfolder, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400)

*!*	_apicreatedirectory(m.targetfolder, 0)

*!*	_apicreatedirectory(m.targetfolder + '\overrides', 0)


*!* GENERATE MANIFEST.JSON

m.minecraft_version	= sql_gcf.gver
m.modloaders_id		= sql_gcf.mname

text to m.manifest textmerge noshow
{
  "minecraft": {
    "version": "<<m.minecraft_version>>",
    "modLoaders": [
      {
        "id": "<<m.modloaders_id>>",
        "primary": true
      }
    ]
  },
  "manifestType": "minecraftModpack",
  "manifestVersion": 1,
ENDTEXT

m.manifest = m.manifest + 0h0d0a

m.nlines = alines(lalines, inst_gcf.icfdata)

for m.lnx = 1 to m.nlines

	m.manifest = m.manifest + space(2) + m.lalines(m.lnx) + ',' + 0h0d0a

endfor

m.manifest = m.manifest + '  "files": [' + 0h0d0a

*!* NOW ADD MOD FILES TO MANIFEST AND GENERATE MODLIST.HTML

select 'mods_gcf'

m.html = '<ul>' + 0h0d0a

m.firstfile = .t.

scan for mods_gcf.iguid == m.piguid

	if lower(justext(mods_gcf.filename1)) = 'disabled'

		loop

	endif

	if mods_gcf.fid1 = 0

		loop

	endif

	if m.firstfile = .f.

		m.manifest = m.manifest + '    },' + 0h0d0a

	endif

	m.manifest = m.manifest + '    {' + 0h0d0a
	m.manifest = m.manifest + '      "projectID": ' + transform(mods_gcf.aid) + ',' + 0h0d0a
	m.manifest = m.manifest + '      "fileID": ' + transform(mods_gcf.fid1) + ',' + 0h0d0a
	m.manifest = m.manifest + '     "required": true' + 0h0d0a

	m.firstfile = .f.

	*!* modlist.html

	*!* https://minecraft.curseforge.com/projects/

	m.html = m.html + '<li><a href="https://minecraft.curseforge.com/projects/' + transform(mods_gcf.aid) + '">' + mods_gcf.aname + ' (by ' + mods_gcf.authorname + ')</a></li>' + 0h0d0a

endscan

m.manifest = m.manifest + '    }' + 0h0d0a
m.manifest = m.manifest + '  ],' + 0h0d0a
m.manifest = m.manifest + '  "overrides": "overrides"' + 0h0d0a
m.manifest = m.manifest + '}'

m.html = m.html + '</ul>' + 0h0d0a

_zipopen()

_zipaddblob(m.manifest, 'manifest.json')

_zipaddblob(m.html, 'modlist.html')

*!* NOW COPY ALL THE OTHER FILES

select 'blacklist_gcf'

set filter to blacklist_gcf.iguid == m.piguid

m.instancefolder = mr_getinstancefolderfrommodsfolder(inst_gcf.ifolder)

if directory(m.instancefolder + '\minecraft')

	m.instancefolder = m.instancefolder + '\minecraft'

endif

if directory(m.instancefolder + '\.minecraft')

	m.instancefolder = m.instancefolder + '\.minecraft'

endif

m.zipbasefolder = m.instancefolder

if empty(inst_gcf.iname)

	m.zipfilename = inst_gcf.izipfolder + justfname(_zipgetzfilepath(m.instancefolder, m.zipbasefolder)) + m.zipfilesuffix

else

	m.zipfilename = _cleanfilename(inst_gcf.izipfolder + lower(chrtran(inst_gcf.iname, ' ', '_')) + m.zipfilesuffix)

endif

*!*	_logwrite('GENERATE INSTANCE ZIP START')

_logwrite('SOURCE FOLDER:', m.instancefolder)

_logwrite('ZIP FILE:', m.zipfilename)

_findfilesinfoldertree(m.instancefolder, '*.*')

select 'foundfiles'

scan

	m.skipfile = .f.

	m.filepath = foundfiles.filename

	m.zfilepath = 'overrides\' + _zipgetzfilepath(foundfiles.filename, m.zipbasefolder)

	m.blpath = foundfiles.filename

	do while not lower(m.blpath) == lower(m.instancefolder)

		m.blmd5 = _md5hashstring(lower(m.blpath))

		if seek(m.blmd5, 'blacklist_gcf', 'blmd5') = .t. and blacklist_gcf.blblack = .t.

			m.skipfile = .t.

			exit

		endif

		m.blpath = justpath(m.blpath)

	enddo

	*!* check if we have a file inside the mods folder

	if foundfiles.filefolder = .f. and lower(justpath(foundfiles.filename)) == lower(inst_gcf.ifolder)

		m.skipfile = .t.

	endif

	*!* add the file to the zip

	if m.skipfile = .f.

		if foundfiles.filefolder = .t.

			m.zfilepath = addbs(m.zfilepath)

		endif

		_logwrite(foundfiles.filename, m.zfilepath)

		_zipaddfile(foundfiles.filename, m.zfilepath)

	endif

endscan

_zipclose(m.zipfilename)

mr_rezipthezip(m.zipfilename)

_logwrite('GENERATE CF MODPACK ZIP END')

mr_gencfmodpackzip_cleanup(m.nselect)

procedure mr_gencfmodpackzip_cleanup

lparameters pnselect

if used('mods_gcf')
	use in 'mods_gcf'
endif

if used('inst_gcf')
	use in 'inst_gcf'
endif

if used('modloaders_gcf')
	use in 'modloaders_gcf'
endif

if used('blacklist_gcf')
	use in 'blacklist_gcf'
endif

if used('sql_gcf')
	use in 'sql_gcf'
endif

_restorearea(m.pnselect)

endproc
 