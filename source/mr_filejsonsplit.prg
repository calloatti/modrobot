*!* mr_filejsonsplit

*!* SPLITS JSON ARRAY OF FILE ITEMS

lparameters pjson

local ojson as 'collection'
local lnx

m.pjson = alltrim(m.pjson, 1, '[', ']')

if left(m.pjson, 1) # '{' or right(m.pjson, 1) # '}'

	error 'invalid json'

endif

m.ojson = createobject('collection')

for m.lnx = 1 to occurs('{"id"', m.pjson) - 1

	m.ojson.add('{"id"' + strextract(m.pjson, '{"id"', ',{"id"', m.lnx))

endfor

m.ojson.add('{"id"' + strextract(m.pjson, '{"id"', '', m.lnx))

return m.ojson