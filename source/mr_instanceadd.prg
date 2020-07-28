*!* mr_instanceadd

lparameters pfolder

local cdata, cfile, ifolder, iguid, iloader, iminecraft, iname, lny, nselect, ojson

m.nselect = select()

if not used('instance_add')

	use 'mr_instances' in 0 again shared alias 'instance_add'

endif

m.iminecraft = 'N/A'
m.iloader	 = 'N/A'
m.iname		 = 'N/A'

m.ifolder	 = m.pfolder

m.cfile = addbs(m.pfolder) + '..\..\instance.cfg'

if file(m.cfile)

	m.cdata = chrtran(filetostr(m.cfile), 0h0a, '|')

	m.iname = strextract(m.cdata, 'name=', '|')

endif

if empty(m.iname)

	m.iname = justfname(justfname(justfname(m.pfolder)))

endif

m.cfile = addbs(m.pfolder) + '..\..\mmc-pack.json'

if file(m.cfile)

	m.ojson = nfjsonread(filetostr(m.cfile))

	if type('m.ojson.components[1]') = 'O'

		for m.lny = 1 to alen(m.ojson.components)

			do case

			case type('m.ojson.components[m.lny].cachedname') # 'C'

			case m.ojson.components[m.lny].cachedname == 'Minecraft'

				m.iminecraft = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].version

			case m.ojson.components[m.lny].cachedname == 'Forge'

				m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].version

			case m.ojson.components[m.lny].cachedname == 'FabricLoader'

				m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].cachedversion

			case m.ojson.components[m.lny].cachedname == 'Fabric Loader'

				m.iloader = m.ojson.components[m.lny].cachedname + ' ' + m.ojson.components[m.lny].version

			endcase

		endfor

	endif

endif

m.iguid =  mr_crc32(m.ifolder)

if seek(m.iguid, 'instance_add', 'iguid') = .f.

	append blank in 'instance_add'

	replace instance_add.iguid with m.iguid in 'instance_add'
	replace instance_add.ifolder with m.ifolder in 'instance_add'

endif

replace instance_add.iname with m.iname in 'instance_add'
replace instance_add.iminecraft with m.iminecraft in 'instance_add'
replace instance_add.iloader with m.iloader in 'instance_add'

if empty(instance_add.icfdata)

	replace instance_add.icfdata with '"name": "ModpackName"' + 0h0d0a + '"version": "1.0.0"' + 0h0d0a + '"author": "AuthorNameCF"' in 'instance_add'

endif

_inisetvalue('MR_INSTANCES_IGUID', instance_add.iguid)

use in 'instance_add'

_restorearea(m.nselect)





