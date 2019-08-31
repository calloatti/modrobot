*!* mr_downloadfile

lparameters premotefile, plocalfile, pproxy

*!* NRESULT 0 FILE DOWNLOAD ERROR
*!* NRESULT 1 FILE DOWNLOAD OK

#define MRDOWNLOAD_ERROR		0
#define MRDOWNLOAD_SUCCESS		1
#define MRDOWNLOAD_FILE_EXISTS	2

#define HTTPREQUEST_PROXYSETTING_PROXY	2

local winhttp as 'winhttp' of 'winhttp'
local bytesdone, bytesperc, bytestotal, contentlength, contentrange, filehandle, nblocksize, nresult
local rangefrom, rangestr, rangeto, tempfile


m.nblocksize =(1024 * 128) - 1

*!* CHECK IF WE ALREADY HAVE THE FILE

*!*	?'_file(m.plocalfile)',_file(m.plocalfile)
*!*	?'_getfilesize(m.plocalfile)',_getfilesize(m.plocalfile)
*!*	?'m.pfilesize',m.pfilesize

m.tempfile = m.plocalfile + '.download'

if not _file(m.plocalfile)

	m.winhttp = newobject('winhttp', 'winhttp')

	if not empty(m.pproxy) && 'localhost:8888'

		m.winhttp.setproxy(HTTPREQUEST_PROXYSETTING_PROXY, m.pproxy)

	endif

	m.winhttp.settimeouts(60000, 60000, 30000, 60000)

	*!* DOWNLOAD IN CHUNKS

	*!* IF WE HAVE A PARTIAL DOWNLOAD, USE IT

	if file(m.tempfile) then

		m.rangefrom = _getfilesize(m.tempfile)

		m.filehandle = fopen(m.tempfile, 2)

		fseek(m.filehandle, 0, 2)

	else

		m.rangefrom = 0

		*!* CREATE TEMP FILE

		m.filehandle = fcreate(m.tempfile, 0)

	endif

	if m.filehandle = -1

		error 'FOPEN/FCREATE ERROR'

	endif

	m.bytestotal = 0

	do while .t.

		m.winhttp.open('GET', m.premotefile, .t.)

		m.winhttp.setrequestheader('User-Agent', 'CurseClient/7.5 (Microsoft Windows NT 6.2.9200.0) CurseClient/7.5.7076.33481')

		m.rangeto = m.rangefrom + m.nblocksize - 1

		m.rangestr = 'bytes=' + transform(m.rangefrom) + '-' + transform(m.rangeto)

		m.winhttp.setrequestheader('Range', m.rangestr)

		m.winhttp.send()

		do while m.winhttp.waitforresponse(0) = 0

			doevents

			_apisleep(50)

		enddo

		*!* Content-Range: bytes 16777216-17182321/17182322

		m.contentrange = m.winhttp.getresponseheader('Content-Range')

		m.bytesdone  = int(val(strextract(m.contentrange, '-', '/')))

		m.bytestotal = int(val(strextract(m.contentrange, '/', '')))

		m.bytesperc  = transform(ceiling(m.bytesdone / m.bytestotal * 100), '999 %')

		_logwrite('RESULT:', m.winhttp.responsestatus, m.bytesperc)

		if m.winhttp.responsestatus # 206 then

			exit

		endif

		*!* WRITE CHUNK TO TEMP FILE

		fwrite(m.filehandle, m.winhttp.responsebody)

		fclose(m.filehandle)

		m.filehandle = fopen(m.tempfile, 2)

		fseek(m.filehandle, 0, 2)

		m.contentlength = val(m.winhttp.getresponseheader('Content-Length'))

		if m.contentlength < m.nblocksize then

			exit

		endif

		m.rangefrom = m.rangefrom + m.nblocksize

	enddo

	*!* CLOSE TEMP FILE

	fclose(m.filehandle)

	*!* RENAME TEMP FILE

	if inlist(m.winhttp.responsestatus, 200, 206) then

		_apimovefile(m.tempfile, m.plocalfile)

		_apisleep(100)

	endif

	*!* Requested Range Not Satisfiable

	if m.winhttp.responsestatus = 416  then

		_apideletefile(m.tempfile)

		_apisleep(100)

	endif

endif

if _getfilesize(m.plocalfile) = m.bytestotal then

	m.nresult = MRDOWNLOAD_SUCCESS

else

	_apideletefile(m.plocalfile)

	m.nresult = MRDOWNLOAD_ERROR

endif

return m.nresult


