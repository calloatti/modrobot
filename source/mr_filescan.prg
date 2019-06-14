*!* mr_filescan

Local forced, nselect, silent


m.nselect = Select()

If Not Used('addons_scan')

   Use 'mr_addons' In 0 Again Shared Alias 'addons_scan'

Endif

If Not Used('files_scan')

   Use 'mr_files' In 0 Again Shared Alias 'files_scan'

Endif

Select 'files_scan'

m.forced = .T.
m.silent = .T.

Scan For Not Empty(files_scan.hfjson)

   Wait files_scan.aid Window Nowait

   DoEvents

   mr_fileparse(files_scan.aid, files_scan.hfjson, m.forced, m.silent)

Endscan

Wait Clear

Use In 'files_scan'

Select(m.nselect) 