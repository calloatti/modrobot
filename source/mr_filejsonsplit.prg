*!* mr_filejsonsplit

*!* SPLITS JSON ARRAY OF FILE ITEMS

Lparameters pjson

Local ojson as 'collection'
Local lnx

m.pjson = Alltrim(m.pjson, 1, '[', ']')

If Left(m.pjson, 1) # '{' Or Right(m.pjson, 1) # '}'

   Error 'invalid json'

Endif

m.ojson = Createobject('collection')

For m.lnx = 1 To Occurs('{"id"', m.pjson) - 1

   m.ojson.Add('{"id"' + Strextract(m.pjson, '{"id"', ',{"id"', m.lnx))

Endfor

m.ojson.Add('{"id"' + Strextract(m.pjson, '{"id"', '', m.lnx))

Return m.ojson 