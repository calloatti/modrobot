*!* mr_parsevanillajson

Local loinstance, ojson

m.ojson = nfjsonread('C:\Users\Mara\AppData\Roaming\.minecraft\launcher_profiles.json')


m.ncount = Amembers(lainstances, m.ojson.profiles)

CLEAR

For m.lnx = 1 To m.ncount
 
   With Evaluate('m.ojson.profiles.' + m.lainstances(m.lnx))
      ?'gamedir      ',IIF( VARTYPE(.gamedir) = 'C', .gamedir, '<default>')
      ?'lastversionid',.lastversionid
      ?'name         ',.Name
      ?'type         ',.Type

   Endwith

Endfor