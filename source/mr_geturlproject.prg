*!* mr_geturlproject

Lparameters paid

Local url

If Vartype(m.paid) = 'N' Then

   m.paid = Transform(m.paid)

Endif

m.url = mr_geturlbase() + '/projects/' + m.paid

Return m.url


