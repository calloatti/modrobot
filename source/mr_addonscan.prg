*!* mr_addonscan

Local nselect

m.nselect = Select()

If Not Used('addons_scan')

   Use 'mr_addons' In 0 Again Shared Alias 'addons_scan'

Endif

select 'addons_scan'

Scan

   Wait addons_scan.aid Window Nowait

   DoEvents

   mr_addonupdate(addons_scan.aid)

Endscan

Wait Clear

Use In 'addons_scan'

_restorearea(m.nselect)