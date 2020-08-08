*!* mr_rezipthezip

lparameters pzipfilename

*!* STUPID HACK TO TRY TO CREATE A CF COMPATIBLE ZIP FILE

Local foldername, nselect, tempfoldername, tempzipname

zipinit()

m.tempfoldername = justpath(m.pzipfilename) + '\' + sys(2015)

m.tempzipname = m.tempfoldername + '.zip'

unzipquick(m.pzipfilename, m.tempfoldername)

*!*	m.nselect = select()

*!*	zipopen(m.tempzipname)

*!*	_findfilesinfoldertree(m.tempfoldername)

*!*	select 'foundfiles'

*!*	scan

*!*		zipfilerelative(foundfiles.filename, JUSTPATH(_zipgetzfilepath(foundfiles.filename, m.tempfoldername)))

*!*	endscan

*!*	zipclose()

*!*	use in 'foundfiles'

*!*	_restorearea(m.nselect)

zipfolderquick(m.tempfoldername)

if application.startmode # 0

	_deletefolder(m.tempfoldername, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400)

endif

_apideletefile(m.pzipfilename)

_apimovefile(m.tempzipname, m.pzipfilename)




 