*!* mr_geturlproject

*!* this still works https://minecraft.curseforge.com/projects/<id>

lparameters paidorslug

local nselect, url

if vartype(m.paidorslug) = 'N' then

	if m.paidorslug = 0

		m.url = ''

	else

		m.nselect = select()

		use 'mr_addons' again in 0 alias 'addons_seek'

		if seek(m.paidorslug, 'addons_seek', 'aid') = .t.

			m.url = mr_geturlbase() + '/mc-mods/' + addons_seek.slug

			use in 'addons_seek'

			_restorearea(m.nselect)

		else

			m.url = 'https://minecraft.curseforge.com/projects/' + transform(m.paidorslug)

		endif

	endif

else

	m.url = mr_geturlbase() + '/mc-mods/' + m.paidorslug

endif

return m.url


