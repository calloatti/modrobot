*!* mr_winhttplog

lparameters pwinnhttp

Local nselect

if _inigetvalue('WINHTTPLOG', 0) = 0

	return

endif

m.nselect = select()

if not used('winhttp_log')

	use 'mr_winhttplog' again alias 'winhttp_log' in 0

endif

append blank in 'winhttp_log'

replace winhttp_log.wdatetime with datetime() in 'winhttp_log'

replace winhttp_log.womethod with m.pwinnhttp.open_method in 'winhttp_log'

replace winhttp_log.wopenurl with m.pwinnhttp.open_url in 'winhttp_log'

replace winhttp_log.woptionurl with m.pwinnhttp.option_url in 'winhttp_log'

if 'gzip' $ m.pwinnhttp.getresponseheader('Content-Encoding') then

	replace winhttp_log.wresbody with _zlibuncompressgzip(m.pwinnhttp.responsebody) in 'winhttp_log'

else

	replace winhttp_log.wresbody with m.pwinnhttp.responsebody in 'winhttp_log'

endif

if 'gzip' $ m.pwinnhttp.getresponseheader('Content-Encoding') then

	replace winhttp_log.wrestext with _zlibuncompressgzip(m.pwinnhttp.responsebody) in 'winhttp_log'

else

	replace winhttp_log.wrestext with m.pwinnhttp.responsetext in 'winhttp_log'

endif

replace winhttp_log.wrheaders with m.pwinnhttp.getallresponseheaders() in 'winhttp_log'

replace winhttp_log.wsendbody with m.pwinnhttp.send_body in 'winhttp_log'

replace winhttp_log.wstatus with m.pwinnhttp.responsestatus in 'winhttp_log'

replace winhttp_log.wstatustxt with m.pwinnhttp.responsestatustext in 'winhttp_log'

use in 'winhttp_log'

_restorearea(m.nselect)

 