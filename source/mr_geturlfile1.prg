*!* mr_buildfileurl

*!* https://edge.forgecdn.net/files/
*!* https://addons.cursecdn.com/files/
*!* https://media.forgecdn.net/files/

Lparameters pfid, pfilename

Local host, part1, part2, remotefile

m.host = 'https://media.forgecdn.net/files/'

m.part1 = Left(Transform(m.pfid), Len(Transform(m.pfid)) - 3)

m.part2 = Transform(Val(Right(Transform(m.pfid), 3)))

return _urlencode(m.host + m.part1 + '/' + m.part2 + '/' + m.pfilename)

 