*!* mr_getfilefromzipdata

Lparameters pdata, pfname

Local cdata, cdoff, cdr_offset, cdr_size, cmeth, crc32, csize, fclen, fname, fnlen, lfh_offset, np
Local ucdata, usize, xflen

m.cdata = m.pdata

m.ubytes = ''

*!* EOCDR [end of central directory record]

If Occurs(0h504b0506, m.cdata) > 0

   m.np = Rat(0h504b0506, m.cdata, 1)

   m.cdr_offset = mr_ctoubin(Substr(m.cdata, m.np + 16, 4))

   m.cdr_size	= mr_ctoubin(Substr(m.cdata, m.np + 12, 4))

   *!* GET CENTRAL DIRECTORY

   m.cdata = Substr(m.pdata, m.cdr_offset + 1, m.cdr_size)

   *!* ITERATE CENTRAL DIRECTORY FILE HEADERS

   m.np = 1

   Do While m.np < m.cdr_size

      *!* central directory file header
      *!* file name length
      *!* extra field length
      *!* file comment length
      *!* file name (variable size)
      *!* compressed size
      *!* crc-32
      *!* compression method

      m.fnlen = mr_ctoubin(Substr(m.cdata, m.np + 28, 2))
      m.fname = Substr(m.cdata, m.np + 46, m.fnlen)
      m.xflen = mr_ctoubin(Substr(m.cdata, m.np + 30, 2))
      m.fclen = mr_ctoubin(Substr(m.cdata, m.np + 32, 2))

      If Upper(m.fname) == Upper(m.pfname)

         m.csize = mr_ctoubin(Substr(m.cdata, m.np + 20, 4))
         m.usize = mr_ctoubin(Substr(m.cdata, m.np + 24, 4))
         m.crc32 = mr_ctoubin(Substr(m.cdata, m.np + 16, 4))
         m.cmeth = mr_ctoubin(Substr(m.cdata, m.np + 10, 2))

         *!* LOCAL FILE HEADER OFFSET

         m.lfh_offset = mr_ctoubin(Substr(m.cdata, m.np + 42, 4))

         *!* GET LOCAL FILE HEADER

         m.cdata = Substr(m.pdata, m.lfh_offset + 1, 30)

         *!* local file header:
         *!* file name length
         *!* extra field length

         m.fnlen = mr_ctoubin(Substr(m.cdata, 26 + 1, 2))
         m.xflen = mr_ctoubin(Substr(m.cdata, 28 + 1, 2))

         m.cdoff = 30 + m.fnlen + m.xflen

         m.cdata = Substr(m.pdata, m.lfh_offset + m.cdoff + 1, m.csize)

         Do Case

            Case m.cmeth = 0

               m.ubytes = m.cdata

            Case m.cmeth = 8

               m.ubytes = _zlibuncompresszip(m.cdata, m.usize, m.crc32)

            Otherwise

               Error 'UNKNOWN COMPRESSION METHOD'

         Endcase

         Exit

      Endif

      m.np = m.np + 46 + m.fnlen + m.xflen + m.fclen

   Enddo

Endif

Return m.ubytes






















