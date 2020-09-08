*!* mr_nbtparse

*!* tagtype 1 byte | namelen 2 bytes | name | tagpaylaod

*!*	00	TAG_End	None.
*!*	01	TAG_Byte	1 byte / 8 bits, signed
*!*	02	TAG_Short	2 bytes / 16 bits, signed, big endian
*!*	03	TAG_Int	4 bytes / 32 bits, signed, big endian
*!*	04	TAG_Long	8 bytes / 64 bits, signed, big endian
*!*	05	TAG_Float	4 bytes / 32 bits, signed, big endian, IEEE 754-2008, binary32
*!*	06	TAG_Double	8 bytes / 64 bits, signed, big endian, IEEE 754-2008, binary64
*!*	07	TAG_Byte_Array	TAG_Int's payload size, then size TAG_Byte's payloads.
*!*	08	TAG_String	TAG_Short's payload length, then a UTF-8 string with size length.
*!*	09	TAG_List	TAG_Byte's payload tagId, then TAG_Int's payload size, then size tags' payloads, all of type tagId.
*!*	0a	TAG_Compound	Fully formed tags, followed by a TAG_End.
*!*	0b	TAG_Int_Array	TAG_Int's payload size, then size TAG_Int's payloads.
*!*	0c	TAG_Long_Array	TAG_Int's payload size, then size TAG_Long's payloads.

#define HEAP_ZERO_MEMORY	8

*m.nbtfile = "F:\MULTIMC\INSTANCES\AOF-STRAWBERRY-1.16.1-3.4.0\.minecraft\servers.dat"

local heap, nbt, nbtfile, nbtlen, nbtlist, nbtpath, strm, tagid, tagname, tagnamelen

m.nbtfile = "F:\MULTIMC\INSTANCES\AOF-STRAWBERRY-1.16.1-3.4.0\.minecraft\saves\TEST1\level.dat"

m.nbt = filetostr(m.nbtfile)

if left(m.nbt, 2) == 0h1f8b

	m.nbt = _zlibuncompressgzip(m.nbt)

endif

m.nbtlen = len(m.nbt)

*!* ALLOCATE MEM

m.heap = _apigetprocessheap()

m.strm = _apiHeapAlloc(m.heap, HEAP_ZERO_MEMORY, m.nbtlen)

*!* COPY BYTES TO MEM

sys(2600, m.strm, m.nbtlen, m.nbt)

m.nbtlist = ''

m.nbtpath = ''

select 'mr_nbtparse'

zap

_screen.addproperty('mr_nbtparse_pos', 1)
_screen.addproperty('mr_nbtparse_path', '')
_screen.addproperty('mr_nbtparse_list', 0)
_screen.addproperty('mr_nbtparse_level', 0)
_screen.addproperty('mr_nbtparse_strm', m.strm)

do while _screen.mr_nbtparse_pos < m.nbtlen

	m.tagid = asc(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, 1))

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + 1

	if m.tagid = 0

		m.tagnamelen = 0

		m.tagname = ''

	else

		m.tagnamelen = ctobin(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, 2), '2s')

		_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + 2

		m.tagname = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagnamelen)

		_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagnamelen

	endif

	mr_nbtparsetag(m.tagid, m.tagname)

enddo

_apiHeapFree(m.heap, 0, m.strm)

procedure mr_nbtparsetag

lparameters ptagid, ptagname

local nbttxt, tagid, tagidlbl, taglistlen, tagpayload, tagpayloadlen, tags

m.tagidlbl = transform(m.ptagid, '@L 99')

do case

case m.ptagid = 0   && TAG_End

	if _screen.mr_nbtparse_list = 0

		_screen.mr_nbtparse_level = _screen.mr_nbtparse_level - 1

	endif

	if _screen.mr_nbtparse_list > 0 then

		_screen.mr_nbtparse_list = _screen.mr_nbtparse_list - 1

	endif

	if _screen.mr_nbtparse_list = 0

		_screen.mr_nbtparse_path  = addbs(justpath(justpath(_screen.mr_nbtparse_path)))

	endif

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path  + 'TAG_End' in 'mr_nbtparse'

case m.ptagid = 1   && TAG_Byte

	m.tagpayloadlen = 1

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 2   && TAG_Short

	m.tagpayloadlen = 2

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 3   && TAG_Int

	m.tagpayloadlen = 4

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 4   && TAG_Long

	m.tagpayloadlen = 8

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 5   && TAG_Float

	m.tagpayloadlen = 4

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 6   && TAG_Double

	m.tagpayloadlen = 8

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 7   && TAG_Byte_Array

	*!* READ LEN OF BYTE ARRAY

	m.tagpayloadlen = 4

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	m.tagpayloadlen = ctobin(m.tagpayload, '4s')

	*!* READ ACTUAL BYTE ARRAY

	m.tagpayload = strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 8   && TAG_String

	*!* READ LEN OF STRING

	m.tagpayloadlen = 2

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	m.tagpayloadlen = ctobin(m.tagpayload, '2s')

	*!* READ ACTUAL STRING

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 9   && TAG_List

	*!* READ ID OF TAG LIST

	m.tagid = asc(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, 1))

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + 1

	*!* READ NUMBER OF PAYLOADS

	m.tagpayloadlen = 4

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	m.taglistlen = ctobin(m.tagpayload, '4s')

	if m.tagid  = 10 then

		_screen.mr_nbtparse_list = m.taglistlen

		_screen.mr_nbtparse_level = _screen.mr_nbtparse_level + 1

		_screen.mr_nbtparse_path  = _screen.mr_nbtparse_path + m.ptagname + '\'

	else

		_screen.mr_nbtparse_list = 0

	endif

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + 'TAG_List' + ':' + m.ptagname + ':' + transform(m.tagid) + ':' + transform(m.taglistlen) in 'mr_nbtparse'

	for m.lnx = 1 to m.taglistlen

		mr_nbtparsetag(m.tagid, '')

	endfor

case m.ptagid = 10   && TAG_Compound

	*!*		if empty(m.ptagname)
	*!*			m.ptagname = '\'
	*!*		endif

	if empty(m.ptagname) and not empty(_screen.mr_nbtparse_path)

		m.ptagname = '.'

	endif

	if _screen.mr_nbtparse_list = 0 then

		_screen.mr_nbtparse_path  = _screen.mr_nbtparse_path + m.ptagname + '\'
		_screen.mr_nbtparse_level = _screen.mr_nbtparse_level + 1

	endif

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + 'TAG_Compound' in 'mr_nbtparse'

case m.ptagid = 11   && TAG_Int_Array

	*!* READ LEN OF ARRAY

	m.tagpayloadlen = 4

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	m.taglistlen = ctobin(m.tagpayload, '4s')

	*!* READ ACTUAL ARRAY

	m.tagpayload = ''

	m.tagpayloadlen = 4

	for m.tags = 1 to m.taglistlen

		m.tagpayload = m.tagpayload + strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15) + ','

		_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	endfor

	m.tagpayload = rtrim(m.tagpayload, 1, ',')

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

case m.ptagid = 12   && TAG_Long_Array

	*!* READ LEN OF ARRAY

	m.tagpayloadlen = 4

	m.tagpayload = sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen)

	_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	m.taglistlen = ctobin(m.tagpayload, '4s')

	*!* READ ACTUAL ARRAY

	m.tagpayload = ''

	m.tagpayloadlen = 8

	for m.tags = 1 to m.taglistlen

		m.tagpayload = m.tagpayload + strconv(sys(2600, _screen.mr_nbtparse_strm + _screen.mr_nbtparse_pos - 1, m.tagpayloadlen), 15) + ','

		_screen.mr_nbtparse_pos = _screen.mr_nbtparse_pos + m.tagpayloadlen

	endfor

	m.tagpayload = rtrim(m.tagpayload, 1, ',')

	append blank in 'mr_nbtparse'

	replace mr_nbtparse.taglevel with _screen.mr_nbtparse_level in 'mr_nbtparse'
	replace mr_nbtparse.tagid with m.ptagid in 'mr_nbtparse'
	replace mr_nbtparse.tagtext with _screen.mr_nbtparse_path + m.ptagname + ':' + m.tagpayload in 'mr_nbtparse'

otherwise

	error 'UNKNOWN TAG ID:' + transform(m.ptagid)

endcase

return m.nbttxt

endproc











































