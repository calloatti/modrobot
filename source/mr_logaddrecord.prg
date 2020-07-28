*!* mr_logaddrecord

lparameters pfid1, pfid2, pfilename1, pfilename2, phash1, phash2, pifolder, piguid, pldesc, pmodid

Local nselect

m.nselect = select()

if not used('log_lar')

	use 'mr_log' again alias 'log_lar' in 0

endif

append blank in 'log_lar'

replace ;
	log_lar.fid1 with m.pfid1, ;
	log_lar.fid2 with m.pfid2, ;
	log_lar.filename1 with m.pfilename1, ;
	log_lar.filename2 with m.pfilename2, ;
	log_lar.hash1 with m.phash1, ;
	log_lar.hash2 with m.phash2, ;
	log_lar.ifolder with m.pifolder, ;
	log_lar.iguid with m.piguid, ;
	log_lar.ldesc with m.pldesc, ;
	log_lar.modid with m.pmodid, ;
	log_lar.ldatetime with datetime() in 'log_lar'


use in 'log_lar'

_restorearea(m.nselect)


 