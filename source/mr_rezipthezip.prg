*!* mr_rezipthezip

lparameters pzipfilename

*!* STUPID HACK TO TRY TO CREATE A CF COMPATIBLE ZIP FILE

Local foldername

do zip.prg

m.foldername = justpath(m.pzipfilename) + '\' + juststem(m.pzipfilename)

UnzipQuick(m.pzipfilename, m.foldername)

ZipFolderQuick(m.foldername)

_deletefolder(m.foldername, _vfp.hwnd, 0x0010 + 0x0004 + 0x0400) 