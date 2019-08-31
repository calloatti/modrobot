* ! * mr_getinstancefolderfrommodsfolder

Lparameters pmodsfolder

Local instancefolder

m.instancefolder = Rtrim(m.pmodsfolder, 1, '\')

If Lower(Justfname(m.instancefolder)) == 'mods'

	m.instancefolder = Justpath(m.instancefolder)

Endif

If Lower(Justfname(m.instancefolder)) == '.minecraft'

	m.instancefolder = Justpath(m.instancefolder)

Endif

Return m.instancefolder
