*!* mr_downloadfile

Lparameters premotefile, plocalfile

*!* NRESULT 0 FILE DOWNLOAD ERROR
*!* NRESULT 1 FILE DOWNLOAD OK

#Define MRDOWNLOAD_ERROR		0
#Define MRDOWNLOAD_SUCCESS		1
#Define MRDOWNLOAD_FILE_EXISTS	2

#Define	TBPF_NOPROGRESS		0
#Define	TBPF_INDETERMINATE	0x1

Local winhttp As 'winhttp' Of 'winhttp'
Local ITaskbarList4, bytesdone, bytesperc, bytestotal, contentlength, contentrange, filehandle
Local nblocksize, nresult, rangefrom, rangestr, rangeto, tempfile

m.nblocksize =(1024 * 128) - 1

*!* CHECK IF WE ALREADY HAVE THE FILE

*!*	?'_file(m.plocalfile)',_file(m.plocalfile)
*!*	?'_getfilesize(m.plocalfile)',_getfilesize(m.plocalfile) 
*!*	?'m.pfilesize',m.pfilesize

m.tempfile = m.plocalfile + '.download'

If Not _file(m.plocalfile)

   m.ITaskbarList4 = com_ITaskbarList4()

   m.ITaskbarList4.HrInit()

   m.winhttp = Newobject('winhttp', 'winhttp')

   *m.winhttp.setproxy(2, 'localhost:8888')

   m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

   *!* DOWNLOAD IN CHUNKS

   *!* IF WE HAVE A PARTIAL DOWNLOAD, USE IT

   If File(m.tempfile) Then

      m.rangefrom = _getfilesize(m.tempfile)

      m.filehandle = Fopen(m.tempfile, 2)

      Fseek(m.filehandle, 0, 2)

   Else

      m.rangefrom = 0

      *!* CREATE TEMP FILE

      m.filehandle = Fcreate(m.tempfile, 0)

   Endif

   If m.filehandle = -1

      Error 'FOPEN/FCREATE ERROR'

   Endif

   Do While .T.

      m.winhttp.Open('GET', m.premotefile, .T.)

      m.winhttp.setrequestheader('User-Agent', 'CurseClient/7.5 (Microsoft Windows NT 6.2.9200.0) CurseClient/7.5.7076.33481')

      m.rangeto = m.rangefrom + m.nblocksize - 1

      m.rangestr = 'bytes=' + Transform(m.rangefrom) + '-' + Transform(m.rangeto)

      m.winhttp.setrequestheader('Range', m.rangestr)

      m.winhttp.Send()

      Do While m.winhttp.waitforresponse(0) = 0

         DoEvents

         _apisleep(50)

      Enddo

      *!* Content-Range: bytes 16777216-17182321/17182322

      m.contentrange = m.winhttp.getresponseheader('Content-Range')

      m.bytesdone  = Int(Val(Strextract(m.contentrange, '-', '/')))

      m.bytestotal = Int(Val(Strextract(m.contentrange, '/', '')))

      m.bytesperc  = Transform(Ceiling(m.bytesdone / m.bytestotal * 100), '999 %')

      m.ITaskbarList4.SetProgressValue(0, m.bytesdone, m.bytestotal)

      _logwrite('RESULT:', m.winhttp.responsestatus, m.bytesperc)

      If m.winhttp.responsestatus # 206 Then

         Exit

      Endif

      *!* WRITE CHUNK TO TEMP FILE

      Fwrite(m.filehandle, m.winhttp.responsebody)

      Fclose(m.filehandle)

      m.filehandle = Fopen(m.tempfile, 2)

      Fseek(m.filehandle, 0, 2)

      m.contentlength = Val(m.winhttp.getresponseheader('Content-Length'))

      If m.contentlength < m.nblocksize Then

         Exit

      Endif

      m.rangefrom = m.rangefrom + m.nblocksize

   Enddo

   m.ITaskbarList4.SetProgressState(0, TBPF_NOPROGRESS)

   m.ITaskbarList4 = Null

   *!* CLOSE TEMP FILE

   Fclose(m.filehandle)

   *!* RENAME TEMP FILE

   If Inlist(m.winhttp.responsestatus, 200, 206) Then

      _apiMoveFile(m.tempfile, m.plocalfile)

      _apisleep(100)

   Endif

   *!* Requested Range Not Satisfiable

   If m.winhttp.responsestatus = 416  Then

      _apideletefile(m.tempfile)

      _apisleep(100)

   Endif

Endif

If _getfilesize(m.plocalfile) = m.bytestotal Then

   m.nresult = MRDOWNLOAD_SUCCESS

Else

   _apideletefile(m.plocalfile)

   m.nresult = MRDOWNLOAD_ERROR

Endif

Return m.nresult











