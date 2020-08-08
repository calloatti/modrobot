*!* mr_explorerhere

lparameters ppath

Local pbc, ppidl, psfgaoOut, pszName, sfgaoIn

if file(m.ppath)

	m.pszName = strconv(m.ppath, 5) + 0h0000

	m.pbc		= 0
	m.ppidl		= 0
	m.sfgaoIn	= 0
	m.psfgaoOut	= 0

	_apiSHParseDisplayName(m.pszName, m.pbc, @m.ppidl, m.sfgaoIn, @m.psfgaoOut)

	if m.ppidl # 0

		_apiSHOpenFolderAndSelectItems(m.ppidl, 0, 0, 0)

		_apiCoTaskMemFree(m.ppidl)

	endif

else

	m.ppath = rtrim(m.ppath, 1, '\')

	if not directory(m.ppath, 1)

		m.ppath = justpath(m.ppath)

		m.ppath = rtrim(m.ppath, 1, '\')

	endif

	if directory(m.ppath)

		mr_shellexecute(m.ppath)

	endif

endif 