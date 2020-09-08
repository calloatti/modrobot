*!* mr_getfilefromzipfile

lparameters pfile, pfname

local bytes, cdoff, cdr_offset, cdr_size, cmeth, crc32, csize, fclen, fname, fnlen, hfile
local lfh_offset, np, ubytes, usize, xflen

if not _file(m.pfile)

	error 'FILE NOT FOUND: ' + m.pfile

endif

m.ubytes = ''

m.hfile = fopen(m.pfile, 0)

if m.hfile < 0

	error 'FOPEN'

endif

fseek(m.hfile, -8192, 2)

m.bytes = fread(m.hfile, 8192)

*!* EOCDR [end of central directory record]

if occurs(0h504b0506, m.bytes) > 0

	m.np = rat(0h504b0506, m.bytes, 1)

	m.cdr_offset = mr_ctoubin(substr(m.bytes, m.np + 16, 4))

	m.cdr_size	= mr_ctoubin(substr(m.bytes, m.np + 12, 4))

	fseek(m.hfile, m.cdr_offset, 0)

	*!* GET CENTRAL DIRECTORY

	m.bytes = fread(m.hfile, m.cdr_size)

	*!* ITERATE CENTRAL DIRECTORY FILE HEADERS

	m.np = 1

	do while m.np < m.cdr_size

		*!* central directory file header
		*!* file name length
		*!* extra field length
		*!* file comment length
		*!* file name (variable size)
		*!* compressed size
		*!* crc-32
		*!* compression method

		m.fnlen	= mr_ctoubin(substr(m.bytes, m.np + 28, 2))
		m.fname	= substr(m.bytes, m.np + 46, m.fnlen)
		m.xflen	= mr_ctoubin(substr(m.bytes, m.np + 30, 2))
		m.fclen	= mr_ctoubin(substr(m.bytes, m.np + 32, 2))

		if upper(m.fname) == upper(m.pfname) or upper(m.fname) == upper(chrtran(m.pfname, '\', '/'))

			m.csize	= mr_ctoubin(substr(m.bytes, m.np + 20, 4))
			m.usize	= mr_ctoubin(substr(m.bytes, m.np + 24, 4))
			m.crc32	= mr_ctoubin(substr(m.bytes, m.np + 16, 4))
			m.cmeth	= mr_ctoubin(substr(m.bytes, m.np + 10, 2))

			*!* LOCAL FILE HEADER OFFSET

			m.lfh_offset = mr_ctoubin(substr(m.bytes, m.np + 42, 4))

			fseek(m.hfile, m.lfh_offset, 0)

			*!* GET LOCAL FILE HEADER

			m.bytes = fread(m.hfile, 30)

			*!* local file header:
			*!* file name length
			*!* extra field length

			m.fnlen	= mr_ctoubin(substr(m.bytes, 26 + 1, 2))
			m.xflen	= mr_ctoubin(substr(m.bytes, 28 + 1, 2))

			m.cdoff = 30 + m.fnlen + m.xflen

			fseek(m.hfile, m.lfh_offset + m.cdoff, 0)

			m.bytes = fread(m.hfile, m.csize)

			do case

			case m.cmeth = 0

				m.ubytes = m.bytes

			case m.cmeth = 8

				m.ubytes = _zlibuncompresszip(m.bytes, m.usize, m.crc32)

			otherwise

				error 'UNKNOWN COMPRESSION METHOD'

			endcase

			exit

		endif

		m.np = m.np + 46 + m.fnlen + m.xflen + m.fclen

	enddo

endif

fclose(m.hfile)

return m.ubytes























