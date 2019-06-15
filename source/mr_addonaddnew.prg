*!* mr_addonaddnew

Local aid, aidmax, aidmin, nselect

m.nselect = Select()

If Not Used('addons_an')

   Use 'mr_addons' In 0 Again Shared Order Tag 'aid' Descending Alias 'addons_an'

Endif

*!* GAPS IN ADDON IDS:

*!*	088625-088656
*!*	103574-103600
*!*	103600-220000
*!*	233832-234830
*!*	239469-240467
*!*	249039-250037

*!* SET ARBITRARY CUTOFF SO WE DON'T GET OLD PROJECTS

m.aidmin = _inigetvalue('MR_ADDON_MIN_ID', 310248)

m.aidmax = mr_addongetmax()

*!* NOW SCAN MR_ADDONS TABLE FOR MISSING ADDON IDS

For m.aid = m.aidmin To m.aidmax

   DoEvents

   If Seek(m.aid, 'addons_an', 'aid') = .F. Then

      mr_addonupdate(m.aid)

   Endif

Endfor

_restorearea(m.nselect) 