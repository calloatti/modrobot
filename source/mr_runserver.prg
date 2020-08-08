*!* mr_runserver

lparameters ppath

if not empty(m.ppath)

	if _FILE(addbs(m.ppath) + 'start.cmd')

		_logwrite('CREATEPROCESS', addbs(m.ppath) + 'start.cmd')

		mr_createprocess(addbs(m.ppath) + 'start.cmd', '')

	else

		_logwrite('CREATEPROCESS ERROR. FILE NOT FOUND:', addbs(m.ppath) + 'start.cmd')

	endif

else

	_logwrite('CREATEPROCESS ERROR. NO SERVER FOLDER SPECIFIED')

endif

