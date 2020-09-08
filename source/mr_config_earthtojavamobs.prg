*!* mr_config_earthtojavamobs


local ajsonold[1], biomecats, biomename, biomesend, biomesstart, glowsquid, jsonnew, jsonold
local jsonoldlines, lnx, tropicalslime

m.jsonold = filetostr("F:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.7.0\.minecraft\config\earthtojavamobs.json")

m.jsonnew = ''

create cursor 'biomes' ('biomeid' n(10), 'biomename' varchar(100), 'biomename2' varchar(100), 'biometemp' n(10, 2), 'biomecat' varchar(20), 'biomertype' varchar(20), 'biomefall' n(10, 2))

append from "F:\MultiMC\instances\AOF-STRAWBERRY-1.16.1-3.7.0\.minecraft\config\tellme\biomes-basic_2020-08-30_11.50.16.csv" type csv

index on biomes.biomename tag 'biomename'

m.jsonoldlines = alines(ajsonold, m.jsonold)

m.biomesstart = .f.
m.biomesend	  = .f.

m.biomecats = ''

for m.lnx = 1 to m.jsonoldlines

	if right(m.ajsonold(m.lnx), 1) == '{'

		m.mobname = upper(strextract(m.ajsonold(m.lnx), '"', '"'))

	endif

	if '"spawnBiomes":' $ m.ajsonold(m.lnx)

		m.biomesstart = .t.
		m.biomesend	  = .f.

		m.jsonnew = m.jsonnew + 0h0d0a + m.ajsonold(m.lnx)

		loop

	endif

	if m.biomesstart = .f.

		if empty(m.jsonnew)

			m.jsonnew = m.ajsonold(m.lnx)

		else

			m.jsonnew = m.jsonnew + 0h0d0a + m.ajsonold(m.lnx)

		endif

		loop

	endif

	if m.biomesstart = .t. and ']' $ m.ajsonold(m.lnx)

		m.biomesstart = .f.
		m.biomesend	  = .t.

	endif

	if m.biomesstart = .t. and m.biomesend = .f.


		*!* IGNORE NON MINECRAFT BIOMES

		if 'ecotones:' $  m.ajsonold(m.lnx)

			loop

		endif

		if 'ecotones:' $  m.ajsonold(m.lnx)

			loop

		endif

		if 'riverredux:' $  m.ajsonold(m.lnx)

			loop

		endif

		if 'lakeside:' $  m.ajsonold(m.lnx)

			loop

		endif

		*!* seek biome and save biome data

		m.biomename = strextract(m.ajsonold(m.lnx), '"', '"')

		if seek(m.biomename, 'biomes', 'biomename') = .t.

			if not biomes.biomecat + '|' $ m.biomecats

				m.biomecats = m.biomecats + biomes.biomecat + '|'

			endif

		endif

		m.jsonnew = m.jsonnew + 0h0d0a + m.ajsonold(m.lnx)

	endif

	if m.biomesend = .t.

		?m.biomecats, ',', m.mobname

		do case

		case m.mobname == 'GLOWSQUID'

			scan for not 'minecraft:' $ biomes.biomename

				if '_river' $ biomes.biomename or 'ocean' $ biomes.biomename or 'swamp' $ biomes.biomename or '_lake' $ biomes.biomename

					if not right(m.jsonnew, 1) == ','

						m.jsonnew = m.jsonnew + ','

					endif

					m.jsonnew = m.jsonnew + 0h0d0a + '      "' + biomes.biomename + '",'

				endif

			endscan

		case m.mobname == 'TROPICALSLIME'

			scan for not 'minecraft:' $ biomes.biomename

				if 'beach' $ biomes.biomename

					if not right(m.jsonnew, 1) == ','

						m.jsonnew = m.jsonnew + ','

					endif

					m.jsonnew = m.jsonnew + 0h0d0a + '      "' + biomes.biomename + '",'

				endif

			endscan

		otherwise

			scan for not 'minecraft:' $ biomes.biomename

				if 'beach' $ biomes.biomename or '_river' $ biomes.biomename or 'ocean' $ biomes.biomename or '_lake' $ biomes.biomename

					loop

				endif

				if empty(m.biomecats)

					if not right(m.jsonnew, 1) == ','

						m.jsonnew = m.jsonnew + ','

					endif

					m.jsonnew = m.jsonnew + 0h0d0a + '      "' + biomes.biomename + '",'

					loop

				endif

				if 'COLD|' $ m.biomecats and not biomes.biomecat $ m.biomecats

					if not right(m.jsonnew, 1) == ','

						m.jsonnew = m.jsonnew + ','

					endif

					m.jsonnew = m.jsonnew + 0h0d0a + '      "' + biomes.biomename + '",'

					loop

				endif

				if biomes.biomecat $ m.biomecats

					if not right(m.jsonnew, 1) == ','

						m.jsonnew = m.jsonnew + ','

					endif

					m.jsonnew = m.jsonnew + 0h0d0a + '      "' + biomes.biomename + '",'

				endif

			endscan

		endcase

		m.jsonnew = rtrim(m.jsonnew, 1, ',')
		m.jsonnew = m.jsonnew + 0h0d0a + m.ajsonold(m.lnx)

		m.biomesend	= .f.
		m.biomecats	= ''

	endif

endfor


_cliptext = m.jsonnew




