*!* mr_instanceaddfolder

*!* The folder is the instances folder of multimc
*!* check each subfolder to see if it contains a minecraft/mods folder

Lparameters pfolder

Local afolders[1], cfolder, lnx, ncount

m.ncount = Adir(afolders, Addbs(m.pfolder) + '*.*', 'D', 1)

For m.lnx = 3 To m.ncount

   m.cfolder = Addbs(m.pfolder) + Addbs(m.afolders[m.lnx, 1]) + '.minecraft\mods'

   If Directory(m.cfolder)

      mr_instanceadd(m.cfolder)

   Endif

   m.cfolder = Addbs(m.pfolder) + Addbs(m.afolders[m.lnx, 1]) + 'minecraft\mods'

   If Directory(m.cfolder)

      mr_instanceadd(m.cfolder)

   Endif

Endfor

 