*!* mr_fingerprint

Lparameters pfilename

Local fp

If File(m.pfilename)

   Declare Integer fingerprint In fingerprint.Dll String

   m.fp = fingerprint(m.pfilename)

   If m.fp < 0

      m.fp = m.fp + Int(2^32)

   Endif

Else

   m.fp = 0

Endif

Return m.fp