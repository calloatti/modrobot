*!* mr_fileparse

Lparameters paid, pfjson, pforce, psilent

Local aid, did, dtype, fid, foldername, guid, gver, gver_files, gverlong, hfjson, lnx, lnz, nselect
Local ojson

If Empty(m.pfjson) Or m.pfjson == '[]' Then

   Return

Endif

m.nselect = Select()

If Not Used('addons_pjf')

   Use 'mr_addons' Again Alias 'addons_pjf' In 0

Endif

If Not Used('filever_pjf')

   Use 'mr_fileversions' Again Alias 'filever_pjf' In 0

Endif

If Seek(m.paid, 'addons_pjf', 'aid') = .F. Then

   _restorearea(m.nselect)

   Return

Endif

If Not Used('gversion_pjf')

   Use 'mr_enum_gameversion' Again Alias 'gversion_pjf' In 0

Endif

If Not Used('fstatus_pjf')

   Use 'mr_enum_filestatus' Again Alias 'fstatus_pjf' In 0

Endif

If Not Used('reltype_pjf')

   Use 'mr_enum_filereleasetype' Again Alias 'reltype_pjf' In 0

Endif

If Not Used('files_pjf')

   Use 'mr_files' Again Alias 'files_pjf' In 0

Endif

*!* SPLIT EACH ELEMENT OF THE FILES JSON TO GET ONE JSON PER FILE

m.hfjson = mr_filejsonsplit(m.pfjson)

For m.lnx = 1 To m.hfjson.Count

   m.ojson = nfjsonread(m.hfjson.Item[m.lnx])

   m.fid = m.ojson.Id

   If m.psilent = .F.

      _logwrite('FILE PARSE START', m.fid)

   Endif

   If Seek(m.fid, 'files_pjf', 'FID') = .F. Then

      Append Blank In 'files_pjf'

      Replace files_pjf.fid With m.fid In 'files_pjf'

   Endif

   If files_pjf.hfjson == m.hfjson.Item[m.lnx] And m.pforce = .F.

      If m.psilent = .F.

         _logwrite('FILE PARSE END', m.fid)

      Endif

      Loop

   Endif

   Replace files_pjf.hfjson With m.hfjson.Item[m.lnx] In 'files_pjf'

   Replace ;
      files_pjf.aauthname With addons_pjf.aauthname, ;
      files_pjf.aid With m.paid, ;
      files_pjf.altfileid With m.ojson.alternatefileid, ;
      files_pjf.aname With addons_pjf.aname, ;
      files_pjf.dispname With m.ojson.displayname, ;
      files_pjf.filedate With m.ojson.filedate, ;
      files_pjf.fileext With Justext(m.ojson.filename), ;
      files_pjf.filelen With m.ojson.filelength, ;
      files_pjf.filename With m.ojson.filename, ;
      files_pjf.filestatus With m.ojson.filestatus, ;
      files_pjf.isalt With Iif(m.ojson.isalternate, 1, 0), ;
      files_pjf.isavail With Iif(m.ojson.isavailable, 1, 0), ;
      files_pjf.hash With m.ojson.packagefingerprint, ;
      files_pjf.rtype With m.ojson.ReleaseType, ;
      files_pjf.spfileid With Nvl(m.ojson.serverpackfileid, 0) In 'files_pjf'


   *!*	   If Seek(files_pjf.filestatus, 'fstatus_pjf', 'eid') = .T.

   *!*	      Replace files_pjf.filestatusname With fstatus_pjf.ename In 'files_pjf'

   *!*	   Endif

   *!* RELEASE TYPE

   If Seek(files_pjf.rtype, 'reltype_pjf', 'eid') = .T.

      Replace files_pjf.rtypename With reltype_pjf.ename In 'files_pjf'

   Endif

   *!* FIND mcmod.info OR fabric.mod.json MODULES

   If Vartype(m.ojson.modules) = 'O'

      For m.lnz = 1 To Alen(m.ojson.modules)

         m.foldername = Lower(m.ojson.modules[m.lnz].foldername )

         Do Case

            Case 'mcmod.info' $ m.foldername

               Replace files_pjf.foldername With 'FORGE' In 'files_pjf'

               *!* NO EXIT HERE SINCE THE JAR CAN ALSO HAVE A fabric.mod.json INSIDE	            

            Case 'fabric.mod.json' $ m.foldername

               Replace files_pjf.foldername With 'FABRIC' In 'files_pjf'

               Exit

         Endcase

      Endfor

   Endif

   *!* UPDATE MR_ENUM_GAMEVERSION

   m.gver_files = ''

   For m.lnz = 1 To Alen(m.ojson.gameversion)

      If Vartype(m.ojson.gameversion[m.lnz]) = 'C'

         m.gver = m.ojson.gameversion[m.lnz]

         m.gver_files = m.gver_files + m.gver + '|'

         If Left(m.gver, 2) = '1.'

            m.gverlong = mr_getgameversionlong(m.gver)

            *!* ADD TO VERSIONS TABLE

            If Seek(m.gver, 'gversion_pjf', 'gver') = .F.

               Append Blank In 'gversion_pjf'

               Replace ;
                  gversion_pjf.gver With m.gver, ;
                  gversion_pjf.gverlong With m.gverlong In 'gversion_pjf'

            Endif

            *!* ADD TO FILEVERSIONS TABLE

            m.guid = _md5hashstring(m.gverlong + Transform(m.fid))

            If Seek(m.guid, 'filever_pjf', 'guid') = .F.

               Append Blank In 'filever_pjf'

            Endif

            Replace ;
               filever_pjf.guid With m.guid, ;
               filever_pjf.aid With files_pjf.aid, ;
               filever_pjf.fid With files_pjf.fid, ;
               filever_pjf.filedate With files_pjf.filedate, ;
               filever_pjf.filename With files_pjf.filename, ;
               filever_pjf.gver With m.gver, ;
               filever_pjf.gverlong With m.gverlong, ;
               filever_pjf.loader With files_pjf.foldername, ;
               filever_pjf.hash With files_pjf.hash In 'filever_pjf'

         Endif

      Endif

      If m.psilent = .F.

         _logwrite('FILE PARSE END', m.fid)

      Endif

   Endfor

   *!* UPDATE THE MC VERSION LIST

   m.gver_files = Rtrim(m.gver_files, 1, '|')

   Replace files_pjf.gver With m.gver_files In 'files_pjf'

Endfor

Use In 'addons_pjf'

Use In 'filever_pjf'

Use In 'gversion_pjf'

Use In 'fstatus_pjf'

Use In 'reltype_pjf'

Use In 'files_pjf'

_restorearea(m.nselect)