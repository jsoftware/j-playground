1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './g130.ijs'
NB. %y ------------------------------------------------------------------

_       -: % 0
_ 4 0.1 -: % 0 0.25 10

'domain error' -: % etx 'abc'
'domain error' -: % etx ;:'Opposable Thumbs'
'domain error' -: % etx u:'abc'
'domain error' -: % etx u:&.> ;:'Opposable Thumbs'
'domain error' -: % etx 10&u:'abc'
'domain error' -: % etx 10&u:&.> ;:'Opposable Thumbs'
'domain error' -: % etx s:@<"0 'abc'
'domain error' -: % etx s:@<"0&.> ;:'Opposable Thumbs'
'domain error' -: % etx <"0@s: ;:'Opposable Thumbs'
'domain error' -: % etx <!.0?2 3


NB. x%y -----------------------------------------------------------------

0.75 -: 3 % 4
_120 -: _12 % 0.1
_ __ -: 3 _4 % 0

'domain error' -: 'abc' % etx 4
'domain error' -: 'abc' %~etx 4
'domain error' -: 4     % etx <'abc'
'domain error' -: 4     %~etx <'abc'
'domain error' -: (u:'abc') % etx 4
'domain error' -: (u:'abc') %~etx 4
'domain error' -: 4     % etx <u:'abc'
'domain error' -: 4     %~etx <u:'abc'
'domain error' -: (10&u:'abc') % etx 4
'domain error' -: (10&u:'abc') %~etx 4
'domain error' -: 4     % etx <10&u:'abc'
'domain error' -: 4     %~etx <10&u:'abc'
'domain error' -: (s:@<"0 'abc') % etx 4
'domain error' -: (s:@<"0 'abc') %~etx 4
'domain error' -: 4     % etx s:@<"0&.> <'abc'
'domain error' -: 4     % etx <"0@s: <'abc'
'domain error' -: 4     %~etx s:@<"0&.> <'abc'
'domain error' -: 4     %~etx <"0@s: <'abc'

'length error' -: 3 4   % etx 5 6 7
'length error' -: 3 4   %~etx 5 6 7
'length error' -: 3 4   % etx i.5 6
'length error' -: 3 4   %~etx i.5 6
'length error' -: 3 4   % etx ?4 2$183164
'length error' -: 3 4   %~etx ?4 2$183164


