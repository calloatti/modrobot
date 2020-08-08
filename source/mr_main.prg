*!* mr_main

Local cdir

_initerrorhandler()

_setpath()

m.cdir = _getapppath() + 'mods'

If Not Directory(m.cdir)

   _apiCreateDirectory(m.cdir,0)

Endif

m.cdir = _getapppath() + 'json'

If Not Directory(m.cdir)

   _apiCreateDirectory(m.cdir,0)

Endif

Do Form mr_main

_VFP.EditorOptions = 'LQkT'

On Shutdown Clear Events

Read Events

On Error
On Shutdown
Cancel
Return

Do _indextables.prg 