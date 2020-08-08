*!* mr_runinstance

lparameters piguid

Local cinst, cmmc, lnx, nselect

m.nselect = select()

if not used('inst_run')

	use 'mr_instances' again alias 'inst_run' in 0

endif

if seek(m.piguid, 'inst_run', 'iguid') = .f.

	messagebox('ERROR: INSTANCE GUID NOT FOUND', 64, 'MODROBOT')

	use in 'inst_run'

	_restorearea(m.nselect)

	return

endif

m.cmmc = ''

for m.lnx = 1 to getwordcount(inst_run.ifolder, '\')

	m.cmmc = m.cmmc + getwordnum(inst_run.ifolder, m.lnx, '\') + '\'

	if _file(m.cmmc + 'multimc.exe')

		m.cmmc = m.cmmc + 'multimc.exe'

		exit

	endif

endfor

*!* GET INSTANCE FOLDER NAME

m.cinst = ''

for m.lnx = 1 to getwordcount(inst_run.ifolder, '\')

	m.cinst = m.cinst + getwordnum(inst_run.ifolder, m.lnx, '\') + '\'

	if _file(m.cinst + 'mmc-pack.json')

		m.cinst = '-l ' + '"' + getwordnum(inst_run.ifolder, m.lnx, '\') + '"'

		exit

	endif

endfor

use in 'inst_run'

_restorearea(m.nselect)

_logwrite('CREATEPROCESS', m.cmmc, m.cinst)

if not empty(m.cmmc) and not empty(m.cinst)

	mr_createprocess(m.cmmc, m.cinst)

endif



 