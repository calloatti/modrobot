*!* mr_fingerprint

lparameters pfilename

local fp

if file(m.pfilename)

	declare integer fingerprint in fingerprint.dll string

	m.fp = fingerprint(m.pfilename)

	if m.fp < 0

		m.fp = m.fp + int(2^32)

	endif

else

	m.fp = 0

endif

return m.fp