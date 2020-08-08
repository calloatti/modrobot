*!* mr_instancegetdata

lparameters pifolder

Local oidata as 'empty'
Local cdata, cfile, lny, ojson

m.oidata = createobject('empty')

addproperty(m.oidata, 'iminecraft', 'N/A')
addproperty(m.oidata, 'iloader', 'N/A')
addproperty(m.oidata, 'iname', 'N/A')

m.cfile = addbs(m.pifolder) + '..\..\instance.cfg'

if file(m.cfile)

	m.cdata = chrtran(filetostr(m.cfile), 0h0a, '|')

	m.oidata.iname = strextract(m.cdata, 'name=', '|')

endif

if empty(m.oidata.iname)

	m.oidata.iname = justfname(justfname(justfname(m.pifolder)))

endif

m.cfile = addbs(m.pifolder) + '..\..\mmc-pack.json'

if file(m.cfile)

	m.ojson = nfjsonread(filetostr(m.cfile))

	if type('m.ojson.components[1]') = 'O'

		for m.lny = 1 to alen(m.ojson.components)

			do case

			case type('m.ojson.components[m.lny].uid') # 'C'

			case m.ojson.components[m.lny].uid == 'net.minecraft'

				m.oidata.iminecraft = m.ojson.components[m.lny].version

			case m.ojson.components[m.lny].uid == 'net.minecraftforge'

				m.oidata.iloader =  'FORGE ' + m.ojson.components[m.lny].version

			case m.ojson.components[m.lny].uid == 'net.fabricmc.fabric-loader'

				m.oidata.iloader = 'FABRIC ' + m.ojson.components[m.lny].version

			endcase

		endfor

	endif

endif

return m.oidata


 