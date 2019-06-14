*!* mr_getgameversionlong

Lparameters pgver

Local lnx, gver, gverlong

m.gver = Alltrim(m.pgver)

m.gver = Chrtran(m.gver, Chrtran(m.gver, '1234567890.', ''), '')

m.gverlong = ''

For m.lnx = 1 To Getwordcount(m.gver, '.')

   m.gverlong = m.gverlong + Padl(Getwordnum(m.gver, m.lnx, '.'), 3, '0') + '.'

Endfor

m.gverlong = Rtrim(m.gverlong, 1, '.')

For m.lnx = 1 To 3 - Getwordcount(m.gver, '.')

   m.gverlong = m.gverlong + '.000'

Endfor

If 'SNAPSHOT' $ Upper(m.pgver) Then

   m.gverlong = m.gverlong + 'A'

Else

   m.gverlong = m.gverlong + 'R'

Endif

Return m.gverlong