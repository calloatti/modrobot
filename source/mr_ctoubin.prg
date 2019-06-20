*!* mr_ctoubin

*!* Converts a binary character representation to an unsigned numeric value

Lparameters pbytes

Local lnx, res

m.res = 0

For m.lnx = 1 To Len(m.pbytes)

   m.res = m.res + Asc(Substr(m.pbytes, m.lnx, 1)) * 2^((m.lnx - 1) * 8)

Endfor

m.res = Int(m.res)

Return m.res