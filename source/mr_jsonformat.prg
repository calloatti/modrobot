*!* mr_jsonformat

lparameters pjson

Local c1, c2, cb, deadchars, instring, json, nlen, nlevel, nseconds, ptr1, ptr1pos, ptr2, ptr2pos

m.nseconds = seconds()

vfp2c32()

m.pjson = alltrim(m.pjson)

m.nlevel = 0

m.instring = .f.

m.nlen = len(m.pjson)

m.ptr1 = allocmem(m.nlen)

m.ptr2 = allocmem(m.nlen * 2)

m.ptr2pos = 0

writebytes(m.ptr1, m.pjson, m.nlen)

m.deadchars = '' + 0h09200d0a

for m.ptr1pos = 0 to m.nlen - 1

	m.cb = readchar(m.ptr1 + m.ptr1pos)

	if m.ptr1pos > 0 then

		m.c1 = readchar(m.ptr1 + m.ptr1pos - 1)

	else

		m.c1 = 'X'

	endif

	if m.ptr1pos < m.nlen - 2 then

		m.c2 = readchar(m.ptr1 + m.ptr1pos + 1)

	else

		m.c2 = 'X'

	endif

	if  m.cb == '"' and not m.c1 == '\'

		m.instring = not m.instring

	endif

	if m.instring = .t.

		writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

		m.ptr2pos = m.ptr2pos + 1

		loop

	endif

	*!* IGNORE TABS, SPACES, CR, LF

	if m.cb $ m.deadchars

		loop

	endif

	*!* ADD A SPACE AFTER ":"

	if m.cb = ':'

		writebytes(m.ptr2 + m.ptr2pos, m.cb + space(1), 2)

		m.ptr2pos = m.ptr2pos + 2

		loop

	endif

	if not m.cb $ ',{}[]'

		writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

		m.ptr2pos = m.ptr2pos + 1

		loop

	endif

	if m.cb == '{' or m.cb == '['

		m.nlevel = m.nlevel + 1

	endif

	if m.cb == '}' or  m.cb == ']'

		m.nlevel = m.nlevel - 1

	endif

	do case

	case m.cb == ','

		writebytes(m.ptr2 + m.ptr2pos, m.cb + 0h0d0a + space(m.nlevel * 2))

		m.ptr2pos = m.ptr2pos + 3 + m.nlevel * 2

	case m.cb == '['

		if m.c2 == ']'

			writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

			m.ptr2pos = m.ptr2pos + 1

		else

			writebytes(m.ptr2 + m.ptr2pos, m.cb + 0h0d0a + space(m.nlevel * 2))

			m.ptr2pos = m.ptr2pos + 3 + m.nlevel * 2

		endif

	case m.cb == ']'

		if m.c1 == '['

			writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

			m.ptr2pos = m.ptr2pos + 1

		else

			writebytes(m.ptr2 + m.ptr2pos, 0h0d0a + space(m.nlevel * 2) + m.cb)

			m.ptr2pos = m.ptr2pos + 3 + m.nlevel * 2

		endif

	case m.cb == '{'

		if m.c2 == '}'

			writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

			m.ptr2pos = m.ptr2pos + 1

		else

			writebytes(m.ptr2 + m.ptr2pos, m.cb + 0h0d0a + space(m.nlevel * 2))

			m.ptr2pos = m.ptr2pos + 3 + m.nlevel * 2

		endif

	case m.cb == '}'

		if m.c1 == '{'

			writebytes(m.ptr2 + m.ptr2pos, m.cb, 1)

			m.ptr2pos = m.ptr2pos + 1

		else

			writebytes(m.ptr2 + m.ptr2pos, 0h0d0a + space(m.nlevel * 2) + m.cb)

			m.ptr2pos = m.ptr2pos + 3 + m.nlevel * 2

		endif

	endcase

endfor

m.json = readbytes(m.ptr2, m.ptr2pos)

freemem(m.ptr1)

freemem(m.ptr2)

?m.ptr2pos, seconds() - m.nseconds

return m.json 