*!* mr_avatar_scan

Local aurl, lnx, ojson

If Not Used('avatars_ascan')

   Use 'mr_avatars' Again Alias 'avatars_ascan' In 0

Endif

If Not Used('addons_ascan')

   Use 'mr_addons' Again Alias 'addons_ascan' In 0

Endif

Select 'avatars_ascan'

Scan For Empty(avatars_ascan.aurl)

   If Seek(avatars_ascan.aid, 'addons_ascan', 'aid')

      m.ojson = nfjsonread(addons_ascan.hajson)

      *!* SAVE AVATAR URL ONLY FOR MINECRAFT GAMES

      If m.ojson.gameid = 432 And Type('m.ojson.attachments[1]') = 'O'

         For m.lnx = 1 To Alen(m.ojson.attachments)

            If m.ojson.attachments[m.lnx].isDefault = .T. Then

               m.aurl = m.ojson.attachments[m.lnx].thumbnailUrl

               If Empty(m.aurl)

                  m.aurl = m.ojson.attachments[m.lnx].url

               Endif

               ?m.aurl

               *!* ONLY IF AVATAR URL CHANGED

               If Not m.aurl == avatars_ascan.aurl

                  Replace avatars_ascan.aurl With m.aurl In 'avatars_ascan'

                  Replace avatars_ascan.avatar With ''  In 'avatars_ascan'

               Endif

               mr_avatardownload(addons_ascan.aid)

               Exit

            Endif

         Endfor

      Endif

   Endif

Endscan


