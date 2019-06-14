*!* mr_murmurhash2

*!* see curse.hashing.dll ComputeHash
*!* see https://box.closed.ru/mu/ for safemul32

#Define HEAP_ZERO_MEMORY	8

Lparameters pfilename, pnormalize

Local fhandle, hash, heap, lnx, nb, nh, nk, nlen, nshift, nsize, seed, strm

If _file(m.pfilename) = .F.

   Return 0

Endif

*!* GET FILE SIZE

m.fhandle = Fopen(m.pfilename)

m.nlen = Fseek(m.fhandle, 0, 2)

Fclose(m.fhandle)

*!* ALLOCATE MEM

m.heap = _apigetprocessheap()

m.strm = _apiHeapAlloc(m.heap, HEAP_ZERO_MEMORY, m.nlen)

*!* COPY BYTES TO MEM

Sys(2600, m.strm, m.nlen, Filetostr(m.pfilename))

If m.pnormalize = .T.

   *!* COUNT VALID BYTES

   m.nsize = 0

   For m.lnx = 1 To m.nlen

      m.nb = Asc(Sys(2600, m.strm + m.lnx - 1, 1))

      If m.nb = 0x9 Or m.nb = 0xd Or m.nb = 0xa Or m.nb = 0x20 Then

         Loop

      Endif

      m.nsize = m.nsize + 1

   Endfor

Else

   m.nsize = m.nlen

Endif

m.seed = 0x1

m.nh = Bitxor(m.seed, m.nsize)

m.nk = 0x0

m.nshift = 0x0

For m.lnx = 1 To m.nlen

   DoEvents

   m.nb = Asc(Sys(2600, m.strm + m.lnx - 1, 1))

   *!* SKIP SOME VALUES (TAB, LF, CR, SPACE)

   If m.pnormalize = .T. And(m.nb = 0x9 Or m.nb = 0xa Or m.nb = 0xd Or m.nb = 0x20) Then

      Loop

   Endif

   m.nk = Bitor(m.nk, Bitlshift(m.nb, m.nshift))

   m.nshift = m.nshift + 0x8

   If m.nshift = 0x20

      m.nk = Bitand(m.nk, 0xffff) * 0x5bd1e995 + Bitlshift(Bitand((Bitrshift(m.nk, 16) * 0x5bd1e995), 0xffff), 16)

      m.nk = Bitxor(m.nk, Bitrshift(m.nk, 0x18))

      m.nk = Bitand(m.nk, 0xffff) * 0x5bd1e995 + Bitlshift(Bitand((Bitrshift(m.nk, 16) * 0x5bd1e995), 0xffff), 16)

      m.nh = Bitand(m.nh, 0xffff) * 0x5bd1e995 + Bitlshift(Bitand((Bitrshift(m.nh, 16) * 0x5bd1e995), 0xffff), 16)

      m.nh = Bitxor(m.nh, m.nk)

      m.nk = 0x0

      m.nshift = 0x0

   Endif

Endfor

*!* RELEASE MEM

_apiHeapFree(m.heap, 0, m.strm)

If m.nshift > 0

   m.nh = Bitxor(m.nh, m.nk)

   m.nh = Bitand(m.nh, 0xffff) * 0x5bd1e995 + Bitlshift(Bitand((Bitrshift(m.nh, 16) * 0x5bd1e995), 0xffff), 16)


Endif

m.nh = Bitxor(m.nh, Bitrshift(m.nh, 13))

m.nh = Bitand(m.nh, 0xffff) * 0x5bd1e995 + Bitlshift(Bitand((Bitrshift(m.nh, 16) * 0x5bd1e995), 0xffff), 16)

m.hash = Bitxor(m.nh, Bitrshift(m.nh, 15))

If m.hash < 0 Then

   m.hash = Int(m.hash + 2^32)

Endif

_logwrite('HASH:', m.hash)

Return m.hash

Procedure mmh2_safemul32

   Lparameters pa, pb

   Return Bitand(m.pa, 0xffff) * m.pb + Bitlshift(Bitand((Bitrshift(m.pa, 16) * m.pb), 0xffff), 16)

Endproc

