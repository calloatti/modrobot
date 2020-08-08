*!* mr_jarinjar


m.jarname = "F:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.2.0-JIJ\.minecraft\mods\aof_strawberry-1.16.1-3.2.0.jar"

m.sourcefolder = "F:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.2.0\.minecraft\mods\"

m.targetfolder = 'META-INF\jars\'

text TO m.json noshow
{
  "schemaVersion": 1,
  "id": "aof_strawberry",
  "name": "AOF: Strawberry",
  "version": "3.2.0",
  "environment": "*",
  "license": "",
  "icon": "",
  "authors": ["TeamAOF"],
  "description": "AOF fat jar",
  "jars": [
ENDTEXT

m.json = m.json + 0h0d0a

_zipopen()

m.nfiles = adir(afiles, m.sourcefolder + '*.jar', '', 1)

for m.lnx = 1 to m.nfiles

	?m.afiles(m.lnx, 1)

	_zipaddfile(m.sourcefolder + m.afiles(m.lnx, 1), m.targetfolder + m.afiles(m.lnx, 1))

	if lnx > 1

		m.json = m.json + ',' + 0h0d0a

	endif

	m.json = m.json + '    {' + 0h0d0a + '      "file": ' + '"' + CHRTRAN(m.targetfolder,'\','/') + m.afiles(m.lnx, 1) + '"' + 0h0d0a + '    }'

endfor

m.json = m.json + 0h0d0a + '  ]' + 0h0d0a + '}'

_zipaddblob(m.json, 'fabric.mod.json')

_zipclose(m.jarname)