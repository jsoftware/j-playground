NB. help

NB. =========================================================
helperror=: 0:

NB. =========================================================
helpplay=: 3 : 0
WF=: ''
ndx=. y i. ' '
dic=. 0 ". ndx{.y
bal=. (ndx+1) }. y
if. dic=0 do.
  s=. helpcontext bal
else.-
  s=. helpcontext1 bal
end.
if. (0=#s) +. 0<#WF do.
  r=. boxj2utf8 '90',WF
else.
  r=. '91',(dic#'nuvoc/'),s
end.
playhtml_j_=: r
(2!:0) getJS_j_
)

NB. =========================================================
helpword=: 3 : 0
r=. ;: :: 0: y
if. r -: 0 do.
  WF=: 'word formation failed: ',(dlb y),LF
else.
  WF=: ,(":r),.LF
end.
)