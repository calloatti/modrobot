*!* mr_geturlfile1

*!* https://edge.forgecdn.net/files/
*!* https://addons.cursecdn.com/files/
*!* https://media.forgecdn.net/files/

Lparameters pfid, pfilename, pnotencoded

Local host, part1, part2, url

m.host = _inigetvalue('URL_CURSEFORGECDN', 'https://media.forgecdn.net/files/')

m.part1 = Left(Transform(m.pfid), Len(Transform(m.pfid)) - 3)

m.part2 = Transform(Val(Right(Transform(m.pfid), 3)))

If m.pnotencoded = .T.

   m.url = m.host + m.part1 + '/' + m.part2 + '/' + m.pfilename

Else

   m.url = _urlencode(m.host + m.part1 + '/' + m.part2 + '/' + m.pfilename)

Endif

Return m.url  