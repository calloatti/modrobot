*!* mr_getfilefromzipfile

Lparameters pfile, pfname

Local bytes, cdoff, cdr_offset, cdr_size, cmeth, crc32, csize, fclen, fname, fnlen, hfile
Local lfh_offset, np, ubytes, usize, xflen

If Not _file(m.pfile)

   Error 'FILE NOT FOUND'

Endif

m.ubytes = ''

m.hfile = Fopen(m.pfile, 0)

If m.hfile < 0

   Error 'FOPEN'

Endif

Fseek(m.hfile, -8192, 2)

m.bytes = Fread(m.hfile, 8192)

*!* EOCDR [end of central directory record]

If Occurs(0h504b0506, m.bytes) > 0

   m.np = Rat(0h504b0506, m.bytes, 1)

   m.cdr_offset = mr_ctoubin(Substr(m.bytes, m.np + 16, 4))

   m.cdr_size	= mr_ctoubin(Substr(m.bytes, m.np + 12, 4))

   Fseek(m.hfile, m.cdr_offset, 0)

   *!* GET CENTRAL DIRECTORY

   m.bytes = Fread(m.hfile, m.cdr_size)

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

      m.fnlen = mr_ctoubin(Substr(m.bytes, m.np + 28, 2))
      m.fname = Substr(m.bytes, m.np + 46, m.fnlen)
      m.xflen = mr_ctoubin(Substr(m.bytes, m.np + 30, 2))
      m.fclen = mr_ctoubin(Substr(m.bytes, m.np + 32, 2))

      If Upper(m.fname) == Upper(m.pfname)

         m.csize = mr_ctoubin(Substr(m.bytes, m.np + 20, 4))
         m.usize = mr_ctoubin(Substr(m.bytes, m.np + 24, 4))
         m.crc32 = mr_ctoubin(Substr(m.bytes, m.np + 16, 4))
         m.cmeth = mr_ctoubin(Substr(m.bytes, m.np + 10, 2))

         *!* LOCAL FILE HEADER OFFSET

         m.lfh_offset = mr_ctoubin(Substr(m.bytes, m.np + 42, 4))

         Fseek(m.hfile, m.lfh_offset, 0)

         *!* GET LOCAL FILE HEADER

         m.bytes = Fread(m.hfile, 30)

         *!* local file header:
         *!* file name length
         *!* extra field length

         m.fnlen = mr_ctoubin(Substr(m.bytes, 26 + 1, 2))
         m.xflen = mr_ctoubin(Substr(m.bytes, 28 + 1, 2))

         m.cdoff = 30 + m.fnlen + m.xflen

         Fseek(m.hfile, m.lfh_offset + m.cdoff, 0)

         m.bytes = Fread(m.hfile, m.csize)

         Do Case

            Case m.cmeth = 0

               m.ubytes = m.bytes

            Case m.cmeth = 8

               m.ubytes = _zlibuncompresszip(m.bytes, m.usize, m.crc32)

            Otherwise

               Error 'UNKNOWN COMPRESSION METHOD'

         Endcase

         Exit

      Endif

      m.np = m.np + 46 + m.fnlen + m.xflen + m.fclen

   Enddo

Endif

Fclose(m.hfile)

Return m.ubytes





















