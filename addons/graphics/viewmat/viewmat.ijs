require 'graphics/bmp graphics/gl2 graphics/png'

coclass 'jviewmat'

coinsert 'jgl2 jni jaresu'

IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
IFPLAY=: (IFPLAY"_)^:(0=4!:0<'IFPLAY')0
3 : 0''
if. 0~: 4!:0<'VIEWMATGUI' do.
  VIEWMATGUI=: (IFQT +. IFJA +. ((;:'jwin32 jjava')e.~<11!:0 ::0:'qwd')) > IFJHS +. IFIOS
end.
EMPTY
)
MINWH=: 200 200
DEFWH=: 360 360

VISIBLE=: 1

3 : 0''
if. ('Android'-:UNAME) > IFJA do.
  android_getdisplaymetrics 0
  MINWH=: <. MINWH * DM_density_ja_
  if. IFQT+.IFJA+.VIEWMATGUI do.
    DEFWH=: ,~ <./ <. 2 3{ ". wd'qscreen'
  elseif. 3=4!:0<'getdisplaymetrics_ja_' do.
    DEFWH=: ,~ <./ <. 5 3{getdisplaymetrics_ja_ 0
  end.
elseif. IFIOS do.
  MINWH=: >IFIPAD{310 150;758 250
  DEFWH=: (>:IFRETINA)* MINWH
elseif. IFJA do.
  DM_density_ja_=: {. ". wd 'dm'
end.
EMPTY
)

create=: 0:
onStart=: 3 : 0
vmwin mwh0
)
destroy=: 3 : 0
codestroy''
)
finite=: x: ^: _1
intersect=: e. # [
citemize=: ,: ^: (2: > #@$)
rndint=: <.@:+&0.5
tomatrix=: (_2 {. 1 1 , $) $ ,
fitvm=: 4 : 0
'w h'=. x
mat=. y
'r c'=. $ mat
exp=. (- 0: , }:) <. 0.5 + +/\ r $ h % r
mat=. exp # mat
exp=. (- 0: , }:) <. 0.5 + +/\ c $ w % c
exp #"1 mat
)
delinf=: 3 : 0
if. +:/ _ __ e. ,y do. y return. end.
sc=. 0.1
a=. (,y) -. _ __
max=. >./a
min=. <./a
ext=. sc * max - min
(min-ext) >. y <. max+ext
)
getbitmap=: 3 : 0
glsel'g'
box=. 0 0,glqwh''
res=. glqpixels box
(3 2 { box) $ res
)
gethue=: 4 : 0
y=. y*<:#x
b=. x {~ <.y
t=. x {~ >.y
k=. y-<.y
(t*k) + b*-.k
)
getvm=: 4 : 0
'dat tit'=. 2 {. boxopen y
tit=. ": tit
tit=. tit, (0=#tit) # 'viewmat'
if. ifRGB do.
  mat=. dat
  ang=. ''
else.
  'mat ang'=. x getvm1 dat
end.
if. 2<#$mat do.
  sminfo 'Data rank not supported in viewmat: ',":#$mat
  mat=. ''
end.
dat ; mat ; ang ; tit
)
getvm1=: 4 : 0
hue=. x
mat=. y
ang=. ''
if. 2 > #$hue do.
  hue=. |."1 [ 256 256 256 #: ,hue
end.
select. 3!:0 mat
case. 2;32 do.
  mat=. (, i. ]) mat
case. 16 do.
  ang=. * mat
  mat=. delinf | mat
case. do.
  mat=. finite mat
end.
select. #$mat
case. 0 do.
  mat=. 1 1$mat
case. 1 do.
  mat=. citemize mat
case. 2 do.
case. do.
  mat;'' return.
end.
if. */ (,mat) e. 0 1 do.
  if. #hue do.
    h=. <. 0 _1 { hue
  else.
    h=. 0 ,: 255 255 255
  end.
  mat=. mat { h
else.
  if. #hue do.
    h=. hue
  else.
    h=. 255 * #: 7 | 3^i.6
  end.
  val=. ,mat
  max=. >./ val
  min=. <./ val
  mat=. <. h gethue (mat - min) % max - min
end.

mat=. mat +/ .* 65536 256 1

mat ; ang

)
hadd=: 3 : 0
setvmh VMH,~coname''
)
hcascade=: 3 : 0
''
)
hforms=: 3 : 0
fms=. <;._2 &> <;._2 wdqpx''
fms=. fms #~ (2{"1 fms) e. VMH
fms \: 0 ". &> 4{"1 fms
)
hremove=: 3 : 0
setvmh VMH -. coname''
)
setvmh=: 3 : 0
VMH_jviewmat_=: (~.y) intersect conl 1
)
rgb1=: 256&(#. flipwritergb_jbmp_)
no_gui_bitmap=: 3 : 0
mat=. finite MAT
'rws cls'=. $mat
mwh=. cls,rws
if. -. ifRGB do.
  mwh=. MINWH >. <. mwh * <./ DEFWH % cls,rws
end.
mat=. mwh fitvm mat
)
vmcc=: 4 : 0
ifRGB=: x -: 'rgb'
'mat gid'=. y
'DAT MAT ANG TITLE'=: x getvm mat
if. 0 e. $MAT do. return. end.
mat=. finite MAT
'rws cls'=. $mat
glsel ":gid
glnodblbuf 0
mwh=. glqwh''
if. #ANG do. mwh vf_show mat return. end.
mat=. , mwh fitvm mat
glpixels (0 0, mwh), mat (27 b.) 16bffffff
)
viewmat_jctrl_fkey=: 3 : 'labnext_jlab_ :: ] '''''
viewmat_sctrl_fkey=: 3 : 0
fl=. jpath '~temp/',TITLE,'.png'
wd 'psel viewmat'
(getbitmap'') writepng fl
)
viewmat_g_resize=: 3 : 0
if. needresize do.
  adjwh mwh0
  hcascade''
  hadd''
end.
needresize=: 0
)
viewmat_g_paint=: 3 : 0
try.
mat=. finite MAT
'rws cls'=. $mat
gwh=. glqwh''
if. ifRGB > SHOW do.
  glbrush glrgb 0 0 0
  glrect 0 0,gwh
  mwh=. cls,rws
else.
  mwh=. gwh
end.
if. #ANG do. mwh vf_show mat return. end.
mat=. , mwh fitvm mat
glpixels (0 0, mwh), setalpha mat
glpaintx^:IFJA ''
SHOW=: 1
EMPTY
catch.
viewmat_close''
echo 13!:12''
end.
)
viewmat_close=: 3 : 0
hremove''
wd 'psel ',syshwndp,';pclose'
destroy''
1
)
viewmat_focus_in=: hadd
viewmat_key_press=: 3 : 0
if. isesckey y do. viewmat_close'' else. 0 end.
)
window_delete=: viewmat_cancel=: viewmat_close
fitvf=: 4 : 0

hw=. |. x

'h w'=. hw

mat=. y
'r c'=. s=. $ mat

mat=. ({."1 mat),.mat,.{:"1 mat
mat=. ({.mat),mat,{:mat

mat=. 256 256 256 #: mat

'r2 c2'=. s + 2
'h2 w2'=. <. hw * (r2,c2) % r,c

x=. (c2-1) * (i.w2+1) % w2
k=. x - <. x
b=. (<.x) {"2 mat
t=. (>.x) {"2 mat
mat=. (t *"2 k) + b *"2 -.k

x=. (r2-1) * (i.h2+1) % h2
k=. x - <. x
b=. (<.x) { mat
t=. (>.x) { mat
mat=. (t * k) + b * -.k
mat=. 256 #. >. mat

'xr xc'=. <. -: ($mat) - hw
hw {. xc }."1 xr }. mat
)
vf_show=: 4 : 0

mwh=. x
mat=. y
'rws cls'=. $mat
mat=. , mwh fitvf mat

glrgb 0 0 0
glpen 1 1
glbrush''

glpixels (0 0, mwh), setalpha mat
len=. <. <./ 'scls srws'=. mwh % cls,rws
x=. (-:scls) + scls * i. cls
y=. (-:srws) + srws * i. rws
mid=. x j."1 0 y

if. len < 3 do.
elseif. len e. 3 4 do.
  pixel=. _1 + i.len
  glpixel _2 [\ , rndint +."1 mid + + ANG */ pixel
elseif. len < 20 do.
  ext=. -: len * 0.75
  lines=. ext ,. (-ext), ext - ext * 0.7 * 1j0.8
  gllines _4 [\ , rndint +."1 mid + + ANG */ lines
elseif. do.
  ext=. -: len * 0.75
  lines=. ext , -ext
  gllines _4 [\ , rndint +."1 mid + + ANG */ lines
  poly=. ext - 0,(10 <. len*0.2) * 1j0.6,0.6,1j_0.6
  glpolygon _8 [\ , rndint +."1 mid + + ANG */ poly
end.

)
closeall=: 3 : 0
for_loc. setvmh VMH do.
  viewmat_close__loc''
end.
)
getsize=: 3 : 0
fms=. hforms''
if. 0=#fms
do. sminfo 'viewmat';'No viewmat forms.' return.
end.
wd 'psel ',(<0 1) pick fms
_2 {. wdqchildxywh 'g'
)
readmat=: 3 : 0
fms=. hforms''
if. 0=#fms do.
  sminfo 'viewmat';'No viewmat forms.' return.
end.
wd 'psel ',(<0 1) pick fms
getbitmap''
)
savemat=: 3 : 0
fl=. y
if. 0 = #fl do.
  fl=. jpath '~temp/viewmat.png'
end.
fms=. hforms''
if. 0=#fms
do. sminfo 'viewmat';'No viewmat forms.' return.
end.
wd 'psel ',(<0 1) pick fms
(getbitmap'') writepng fl
)
setsize=: 3 : 0
fms=. hforms''
if. 0=#fms
do. sminfo 'viewmat';'No viewmat forms.' return.
end.
loc=. (<0 2) { fms
wd 'psel ',(<0 1) pick fms
form=. wdqform''
xywh=. wdqchildxywh 'g'
dif=. 0 0, y - _2 {. xywh
wd 'pmove ',":form + dif
)
viewbmp=: 3 : 0
'' viewbmp y
:
dat=. readbmp y
if. 2 = 3!:0 dat do. return. end.
'rgb' viewmat dat;x
)
viewpng=: 3 : 0
'' viewpng y
:
dat=. readpng y
if. 2 = 3!:0 dat do. return. end.
'rgb' viewmat dat;x
)
viewmat=: 3 : 0
'' viewmat y
:
a=. '' conew 'jviewmat'
xx__a=: x [ yy__a=: y
if. IFPLAY do. x viewmat_play y return. end.
if. VIEWMATGUI do.
  empty vmrun__a ''
else.
  empty vmrun__a ''
  (setalpha no_gui_bitmap__a'') writepng jpath '~temp/',TITLE__a,'.png'
  TITLE=. TITLE__a
  destroy__a ''
  if. VISIBLE do.
    if. IFJHS do.
      r=. '~temp/',TITLE,'_',(}.jhsuqs''),'.png'
      (jpath r) frename jpath '~temp/',TITLE,'.png'
      jhspng r
    elseif. IFIOS do.
      uqs=. '?',((":6!:0'')rplc' ';'_';'.';'_')
      r=. '~temp/',TITLE,'_',(}.uqs),'.png'
      (iospath@jpath r) frename iospath@jpath '~temp/',TITLE,'.png'
      t=. '<img src="',(iospath@jpath r),uqs,'"></img>'
      jh t
    elseif. UNAME-:'Android' do.
      android_exec_host 'android.intent.action.VIEW';('file://',jpath '~temp/',TITLE,'.png');'image/png';0
    elseif. do.
      viewimage_j_ jpath '~temp/',TITLE,'.png'
    end.
  end.
end.
)
jhspng=: 3 : 0
d=. fread y
w=. 256#.a.i.4{.16}.d
h=. 256#.a.i.4{.20}.d
t=. '<img width=<WIDTH>px height=<HEIGHT>px src="<FILE><UQS>" ></img>'
jhtml t hrplc_jhs_ 'WIDTH HEIGHT FILE UQS';w;h;y;jhsuqs''
)
viewmatcc=: 3 : 0
'' viewmatcc y
:
empty x vmcc y
)
viewmat_play=: 4 : 0
a=. '' conew 'jviewmat'
xx__a=: x [ yy__a=: y
empty vmrun__a ''
(setalpha no_gui_bitmap__a'') writepng '/viewmat.png'
destroy__a ''
d=. tobase64_base_ fread '/viewmat.png'
playhtml_j_=: '8',d
(2!:0) getJS_j_
)
vmrun=: 3 : 0
x=. xx [ y=. yy
if. 0 > nc <'VMH' do. setvmh '' end.
SHOW=: 0
ifRGB=: x -: 'rgb'
'DAT MAT ANG TITLE'=: x getvm y
if. 0 e. $MAT do. return. end.
mat=. finite MAT
'rws cls'=. $mat
mwh=. cls,rws
if. -. ifRGB do.
  mwh=. MINWH >. <. mwh * <./ DEFWH % cls,rws
end.
mwh0=: mwh
if. IFJA do.
  needresize=: 1
  wd 'activity ',(>coname'')
else.
  vmwin^:VIEWMATGUI mwh
  hcascade''
  hadd''
end.
)
vmwin=: 3 : 0
if. IFQT do.
  wd 'pc viewmat;pn *',TITLE
  wd 'minwh ', ":mwh0
  wd 'cc g isigraph flush'
  wd 'pshow'
elseif. IFJA do.
  wd 'pc viewmat;pn *',TITLE
  wd 'wh _1 _1;cc g isigraph flush'
  wd 'pshow'
elseif. do.
  wd 'pc6j viewmat;pn *',TITLE
  wd 'xywh ', ":0 0, <.@(*&0.5) mwh0
  wd 'cc g isigraph'
  wd 'pshow'
end.
EMPTY
)
adjwh=: 3 : 0
wh0=. y
'w h'=. 2}. ". wd 'qform'
if. (%/wh0) < w%h do.
  h1=. h [ w1=. h * (%/wh0)
else.
  w1=. w [ h1=. w % (%/wh0)
end.
if. IFQT do.
  wd 'set g wh ',":w1,h1
elseif. IFJA do.
  wd 'set g wh ',": <. (w1,h1) % DM_density_ja_
elseif. do.
  wd 'setxywhx g ',":0 0,w1,h1
end.
EMPTY
)
isigraph_event=: 4 : 0
evt=. >@{.y
syshandler=. 'viewmat_handler'
sysevent=. 'viewmat_g_', evt
sysdefault=. 'viewmat_default'
wdd=. ;: 'syshandler sysevent sysdefault'
wdqdata=. (wdd ,. ".&.>wdd)
evthandler wdqdata
0
)
finalize_jviewmat_^:(3=(4!:0)@<) 'finalize_jviewmat_'
viewmat_z_=: viewmat_jviewmat_
viewbmp_z_=: viewbmp_jviewmat_
viewpng_z_=: viewpng_jviewmat_
viewrgb_z_=: 'rgb' & viewmat_jviewmat_
rgb1_z_=: rgb1_jviewmat_
