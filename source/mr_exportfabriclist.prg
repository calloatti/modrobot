*!* mr_exportfabriclist

Local cfile, crlf, furl, purl

select * From mr_files Order By aname, filename Where 'FABRIC' $ mr_files.foldername Into Cursor sqlres

m.cfile = 'C:\VFPP\CURSE\docs\fabric-files.txt'

m.crlf = 0h0d0a

Strtofile('##List of Fabric mod files on CurseForge' + m.crlf, m.cfile, 0)
Strtofile(m.crlf, m.cfile, 1)


Strtofile(Ttoc(Datetime(), 3) + m.crlf, m.cfile, 1)
Strtofile(m.crlf, m.cfile, 1)
Strtofile('Mod Name | File Name|MC Ver', m.cfile, 1)
Strtofile(m.crlf, m.cfile, 1)
Strtofile('---|---|---', m.cfile, 1)
Strtofile(m.crlf, m.cfile, 1)

Select 'sqlres'

Scan

   m.purl = 'https://minecraft.curseforge.com/projects/' + Transform(sqlres.aid)
   m.furl = 'https://minecraft.curseforge.com/projects/' + Transform(sqlres.aid) + '/files/' + Transform(sqlres.fid)

   Strtofile('[' + sqlres.aname + '](' + m.purl + ')|', m.cfile, 1)
   Strtofile('[' + sqlres.filename + '](' + m.furl + ')|', m.cfile, 1)
   Strtofile(sqlres.gver + m.crlf, m.cfile, 1)


Endscan


