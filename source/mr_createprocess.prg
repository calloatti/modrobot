*!* mr_createprocess

lparameters lpapplicationname, lpcommandline

local cprocessinfo, cstartupinfo, hprocess, hthread, lpprocessinformation, lpstartupinfo, result

declare integer CreateProcess in WIN32API as _apicreateprocess_sss ;
	string  lpApplicationName, ;
	string  lpCommandLine, ;
	integer lpProcessAttributes, ;
	integer lpThreadAttributes, ;
	integer bInheritHandles, ;
	integer dwCreationFlags, ;
	integer lpEnvironment, ;
	string  lpCurrentDirectory, ;
	string  lpStartupInfo, ;
	string  @lpProcessInformation

m.lpprocessinformation = replicate(chr(0), 16)

m.lpstartupinfo = 0h44000000 + replicate(chr(0), 64)

if empty(m.lpcommandline)

	m.lpcommandline = ''

endif

m.lpcurrentdirectory = justpath(m.lpapplicationname)

m.result = _apicreateprocess_sss(m.lpapplicationname, m.lpcommandline, 0, 0, 1, 0, 0, m.lpcurrentdirectory, m.lpstartupinfo, @m.lpprocessinformation)

m.hprocess = mr_ctoubin(substr(m.lpprocessinformation, 1, 4))
m.hthread  = mr_ctoubin(substr(m.lpprocessinformation, 5, 4))

_apiclosehandle(m.hprocess)
_apiclosehandle(m.hthread)

return m.result