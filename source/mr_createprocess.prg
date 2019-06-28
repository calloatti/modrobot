*!* mr_createprocess

Lparameters lpApplicationName, lpCommandLine

Local cProcessInfo, cStartupInfo, hProcess, hThread, lpProcessInformation, lpStartupInfo, result

Declare Integer CreateProcess In WIN32API As _apiCreateProcess_sss ;
   String  lpApplicationName, ;
   String  lpCommandLine, ;
   Integer lpProcessAttributes, ;
   Integer lpThreadAttributes, ;
   Integer bInheritHandles, ;
   Integer dwCreationFlags, ;
   Integer lpEnvironment, ;
   String  lpCurrentDirectory, ;
   String  lpStartupInfo, ;
   String  @lpProcessInformation

m.lpProcessInformation = Replicate(Chr(0), 16)

m.lpStartupInfo = 0h44000000 + Replicate(Chr(0), 64)

If Empty(m.lpCommandLine)

   m.lpCommandLine = ''

Endif

m.lpCurrentDirectory = Justpath(m.lpApplicationName)

m.result = _apiCreateProcess_sss(m.lpApplicationName, m.lpCommandLine, 0, 0, 1, 0, 0, m.lpCurrentDirectory, m.lpStartupInfo, @m.lpProcessInformation)

m.hProcess = mr_ctoubin(Substr(m.lpProcessInformation, 1, 4))
m.hThread  = mr_ctoubin(Substr(m.lpProcessInformation, 5, 4))

_apiCloseHandle(m.hProcess)
_apiCloseHandle(m.hThread)

Return m.result