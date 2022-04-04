NB. =========================================================
NB. showcolor    - show colors
NB.
NB. showcolor colormatrix
NB.
NB. colormatrix is a single RBG triplet, or 3 column matrix of RGB triplets
NB.
NB. e.g.  showcolor ?100 3$255
NB.       showcolor ".  COLORTABLE
NB.       showcolor STDCLR_jzplot_

coclass 'jshowcolor'

require 'gl2'
coinsert 'jgl2'

NB. =========================================================
create=: 3 : 0
Colors=: ,: ^: (1=#@$) y
wd 'pc showcolor escclose'
wd 'cc g isigraph'
wd 'pmove 0 0 600 500;pcenter;pshow'
)

NB. =========================================================
destroy=: 3 : 0
wd ::] 'pclose'
codestroy''
)

NB. =========================================================
showcolor_g_paint=: 3 : 0
'w h'=. glqwh''
num=. #Colors
rws=. <. %: num
cls=. >. num % rws
irws=. w % rws
icls=. h % cls
xy=. > , |: { (irws * i.rws);icls * i.cls
rect=. <. 0.5 + num {. xy ,"1 irws,icls
cmd=. glrect@[ glbrush@glrgb
(0 0,w,h) cmd 128 128 128
rect cmd"1 Colors
)

NB. =========================================================
showcolor_close=: 3 : 0
destroy''
)

NB. =========================================================
showcolor_z_=: 3 : 0
y conew 'jshowcolor'
)

NB. =========================================================
cocurrent 'base'
