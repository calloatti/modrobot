*!* mr_pasteupload

Lparameters pname, pcontents

*!*	0h08 Backspace is replaced with \b
*!*	0h0c Form feed is replaced with \f
*!*	0h0a Newline is replaced with \n
*!*	0h0d Carriage return is replaced with \r
*!*	0h09 Tab is replaced with \t
*!*	Double quote is replaced with \"
*!*	Backslash is replaced with \\

*!* POST https://api.paste.ee/v1/pastes HTTP/1.1
*!*	User-Agent: MultiMC/5.0 (Uncached)
*!*	Content-Type: application/json
*!*	X-Auth-Token: xxx
*!*	Content-Length: 60336

Local winhttp As 'winhttp' Of 'winhttp'
Local contents, nselect, ojson, pbody, result, token, url

m.nselect = Select()

If Not Used('pastes_up')

   Use 'mr_pastes' Again Alias 'pastes_up' In 0

Endif

m.contents = m.pcontents

m.contents = Strtran(m.contents, '\', '\\')
m.contents = Strtran(m.contents, 0h08, '\b')
m.contents = Strtran(m.contents, 0h0c, '\f"')
m.contents = Strtran(m.contents, 0h0a, '\n')
m.contents = Strtran(m.contents, 0h0d, '\r')
m.contents = Strtran(m.contents, 0h09, '\t')
m.contents = Strtran(m.contents, '"', '\"')

m.winhttp = Newobject('winhttp', 'winhttp')

m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

m.pbody = '{"description":"modrobot upload","sections":[{"name":"' + Alltrim(m.pname) + '","syntax":"text","contents":"' + m.contents + '"}]}'

m.url = 'https://api.paste.ee/v1/pastes'

m.token = mr_pastegettoken()

m.winhttp.Open('POST', m.url, .T.)

m.winhttp.setrequestheader('User-Agent', 'modrobot')
m.winhttp.setrequestheader('Content-Type', 'application/json')
m.winhttp.setrequestheader('X-Auth-Token', m.token)

m.winhttp.Send(m.pbody)

Do While m.winhttp.waitforresponse(0) = 0

   DoEvents

   _apisleep(50)

Enddo

If m.winhttp.responsestatus = 201

   m.ojson = nfjsonread(m.winhttp.responsetext)

   If m.ojson.success = .T.

      Append Blank In 'pastes_up'

      Replace ;
         pastes_up.pid With m.ojson.id, ;
         pastes_up.purl With m.ojson.Link, ;
         pastes_up.pdatetime With Datetime(), ;
         pastes_up.ptext With m.pcontents, ;
         pastes_up.pname With m.pname In 'pastes_up'

      m.result = Messagebox(m.ojson.Link + 0h0d0a0d0a + 'Open link?', 4 + 64)

      If m.result = 6

         mr_shellexecute(m.ojson.Link)

      Endif


   Endif

Else

   m.result = Messagebox('Upload failed!', 48)

Endif

Use In 'pastes_up'

_restorearea(m.nselect)