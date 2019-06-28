*!* mr_geturlproject

Lparameters paidorslug

Local nselect, url

If Vartype(m.paidorslug) = 'N' Then

   m.nselect = Select()

   Use 'mr_addons' Again In 0 Alias 'addons_seek'

   = Seek(m.paidorslug, 'addons_seek', 'aid')

   m.url = mr_geturlbase() + '/mc-mods/' + addons_seek.slug

   Use In 'addons_seek'

   _restorearea(m.nselect)

Else

   m.url = mr_geturlbase() + '/mc-mods/' + m.paidorslug

Endif

Return m.url
