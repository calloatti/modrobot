*!* mr_exportfabriclist

local cfile, crlf, furl, purl

select * from mr_files order by aname, filename where 'FABRIC' $ mr_files.foldername into cursor sqlres

m.cfile = 'C:\VFPP\CURSE\docs\fabric-files.txt'

m.crlf = 0h0d0a

strtofile('##List of Fabric mod files on CurseForge' + m.crlf, m.cfile, 0)
strtofile(m.crlf, m.cfile, 1)


strtofile(ttoc(datetime(), 3) + m.crlf, m.cfile, 1)
strtofile(m.crlf, m.cfile, 1)
strtofile('Mod Name | File Name|MC Ver', m.cfile, 1)
strtofile(m.crlf, m.cfile, 1)
strtofile('---|---|---', m.cfile, 1)
strtofile(m.crlf, m.cfile, 1)

select 'sqlres'

scan

	m.purl = 'https://minecraft.curseforge.com/projects/' + transform(sqlres.aid)
	m.furl = 'https://minecraft.curseforge.com/projects/' + transform(sqlres.aid) + '/files/' + transform(sqlres.fid)

	strtofile('[' + sqlres.aname + '](' + m.purl + ')|', m.cfile, 1)
	strtofile('[' + sqlres.filename + '](' + m.furl + ')|', m.cfile, 1)
	strtofile(sqlres.gver + m.crlf, m.cfile, 1)


endscan



