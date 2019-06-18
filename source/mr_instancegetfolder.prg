*!* mr_instancegetfolder

Lparameters pfolder

Local lastfolder, selfolder

m.lastfolder = _inigetvalue('ADD_INSTANCE_LAST_FOLDER', Set('Default'))

m.selfolder = Getdir(m.lastfolder, 'Select MultimMC folder/MultimMC instances folder/instance folder/mods folder', '', 1 + 64)

If Not Empty(m.selfolder) Then

   _inisetvalue('ADD_INSTANCE_LAST_FOLDER', m.selfolder)

   Do Case

      Case File(Addbs(m.selfolder) + 'multimc.exe')

         *!* multimc root

         mr_instanceaddfolder(Addbs(m.selfolder) + 'instances')

      Case Lower(Justfname(Rtrim(m.selfolder, 1, '\'))) == 'instances'

         *!* multimc instances root

         mr_instanceaddfolder(Rtrim(m.selfolder, 1, '\'))

      Case Directory(Addbs(m.selfolder) + '.minecraft\mods')

         *!* instance folder

         mr_instanceadd(Addbs(m.selfolder) + '.minecraft\mods')

      Case Directory(Addbs(m.selfolder) + 'minecraft\mods')

         *!* instance folder

         mr_instanceadd(Addbs(m.selfolder) + 'minecraft\mods')

      Case Directory(Addbs(m.selfolder) + 'mods')

         *!* minecraft folder

         mr_instanceadd(Addbs(m.selfolder) + 'mods')

      Otherwise

         *!* mods folder?

         mr_instanceadd(Rtrim(m.selfolder, 1, '\'))

   Endcase

Endif

