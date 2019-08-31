*!* nfjsonsplitmem

*!* IN: 
*!* [{1},{2},{3},{n}]

*!* OUT: collection object ojson[n]

#define HEAP_ZERO_MEMORY	8

lparameters pjson

Local ojson as 'collection'
Local cb, cjson, escapeon, heap, instring, nitemlen, nlevel, np, nstart, stream_size, strm

m.cjson = alltrim(m.pjson, 1, '[', ']')

if left(m.cjson, 1) # '{' or right(m.cjson, 1) # '}'

	error 'invalid json'

endif

m.heap = _apigetprocessheap()

m.stream_size = len(m.cjson)

m.strm = _apiheapalloc(m.heap, HEAP_ZERO_MEMORY, m.stream_size)

sys(2600, m.strm, m.stream_size, m.cjson)

m.ojson = createobject('collection')

m.nlevel = 0

m.instring = .f.

m.escapeon = .f.

m.nstart = 0

m.nitemlen = 0

for m.np = 0 to len(m.cjson) - 1

	m.nitemlen = m.nitemlen + 1

	m.cb = sys(2600, m.strm + m.np, 1)

	if m.instring = .f. and m.nlevel = 0 and m.cb == ','

		m.ojson.add(sys(2600, m.strm + m.nstart, m.nitemlen - 1))

		m.nstart = m.np + 1

		m.nitemlen = 0

	endif

	do case

	case m.instring = .f. and m.cb == '"'

		m.instring = .t.

	case m.instring = .t. and m.cb == '"' and m.escapeon = .f.

		m.instring = .f.

	case m.instring = .t. and m.cb == '\'

		m.escapeon = .t.

	otherwise

		m.escapeon = .f.

	endcase

	if m.instring = .f. and m.cb == '{'

		m.nlevel = m.nlevel + 1

	endif

	if m.instring = .f. and m.cb == '}'

		m.nlevel = m.nlevel - 1

	endif

endfor

*!* ADD LAST ITEM

m.ojson.add(sys(2600, m.strm + m.nstart, m.nitemlen))

_apiheapfree(m.heap, 0, m.strm)

return m.ojson  