*!* mr_ctoubin

*!* Converts a binary character representation to an unsigned numeric value

lparameters pbytes

local lnx, res

m.res = 0

for m.lnx = 1 to len(m.pbytes)

	m.res = m.res + asc(substr(m.pbytes, m.lnx, 1)) * 2^((m.lnx - 1) * 8)

endfor

m.res = int(m.res)

return m.res