*!* mr_getblacklistpath

Lparameters pfilename, pinstancefolder

Local blacklistpath, instancefolder

m.instancefolder = m.pinstancefolder

m.blacklistpath = Strextract(m.pfilename, Addbs(m.instancefolder), '', 1, 1)

Return m.blacklistpath