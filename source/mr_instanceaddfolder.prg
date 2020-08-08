*!* mr_instanceaddfolder

*!* The folder is the instances folder of multimc
*!* check each subfolder to see if it contains a minecraft/mods folder

lparameters pfolder

Local afolders[1], cfolder, iguid, lnx, ncount

m.iguid = ''

m.ncount = adir(afolders, addbs(m.pfolder) + '*.*', 'D', 1)

for m.lnx = 3 to m.ncount

	m.cfolder = addbs(m.pfolder) + addbs(m.afolders[m.lnx, 1]) + '.minecraft\mods'

	if directory(m.cfolder)

		m.iguid = mr_instanceadd(m.cfolder)

	endif

	m.cfolder = addbs(m.pfolder) + addbs(m.afolders[m.lnx, 1]) + 'minecraft\mods'

	if directory(m.cfolder)

		m.iguid = mr_instanceadd(m.cfolder)

	endif

endfor

return m.iguid 