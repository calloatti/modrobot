*!* mr_geturlprojectfiles

Lparameters paid, pfid

If Pcount() = 2

   Return mr_geturlproject(m.paid) + '/files/' + Transform(m.pfid)

Else

   Return mr_geturlproject(m.paid) + '/files'

Endif


