
coclass 'jlab'

LABFILE=: LABDEF=: ''
LABVER=: 1
LAB805=: '~addons/labs/labs/labs805.ijs'
isinteger=: (-: <.) ::0:
matches=: <@[ = #@[ {.each ]
plurals=: ] , (1: ~: [) # 's'"_
setlocale=: 18!:4 @ <
toLF=: }. @ ; @: (LF&, each)
assert=: 3 : 0
'' assert y
:
if. -. 0 e. y do. return. end.
msg=. x
if. 0=#msg do.
  j=. 'There is a problem with the lab.',LF,LF
  msg=. j,'Try re-loading J and starting it again.'
end.
echo msg
laberror=. 13!:8@1:
laberror''
)
delnb=: 3 : 0
y }.~ 3 + 'NB. ' -: 4 {. y
)
getkey=: 3 : 0
hdr=. 0 pick y
tag=. (1 + hdr i. ':') {. hdr
typ=. 6 { tag
ndx=. 1 { I. tag matches y
key=. typ, toLF }. ndx {. y
len=. ndx+1
dat=. len }. y
key;dat;len
)
gettitle=: 3 : 0
txt=. (<0;1) {:: LABDEF
if. 'Lab:' -: 4 {.txt do.
  deb 4 }. txt
else.
  LABFILE
end.
)
getversion=: 3 : 0
dat=. a: -.~ 'b' fread y
if. 0=#dat do. 1 return. end.
a=. 'LABTITLE=:' -: 10 {. (0 pick dat) -. ' '
b=. (<'Lab Section') e. 11 {.each dat
a +: b
)
iscolon=: 3 : 0
t=. ;: :: 0: y
if. t-:0 do. return. end.
if. (<'define') e. t do.
  1 + (2 {. t) -: (,'0');'define' return.
end.
i=. t i. <,':'
if. i=0 do. 0 return. end.
if. -. (,each ':0') -: (i+0 1){t,'';'' do. 0 return. end.
t=. t }.~ -'NB.' -: 3 {. _1 pick t
1 + t -: ,each '0:0'
)
isfilename=: 3 : 0
*./ (2=3!:0 y),(0<#y),':'~:{.y
)
isnb=: 3 : 0
'NB.'-:3{.dlb y
)
isnbkey=: 3 : 0
('NB.labprepare:'-:14 {. y) +. ('NB.labscript:'-:13 {. y)
)
isnote=: 3 : 0
'Note ' -: 5 {. y
)
isnblab=: 3 : 0
('NB.lab'-:6{.y) +. 'NB.spx'-:6{.y
)
remcomments=: 3 : 0
dat=. dlb each y
msk=. (<'NB.') = 3 {.each dat
bal=. (' ' -.~ 3 }. ]) each msk#dat
bal=. (2 < +/@(*./\)@(e.&'-=')) &> bal
y #~ -. msk expand bal
)
remnote=: 3 : 0
len=. 1 + y i. <,')'
(len }. y);len
)
runprepare=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)
runscript=: 3 : 0
SCRIPT=: SCRIPT, y,LF
)

j=. <;._2 (0 : 0)
& &amp;
" &quot;
< &lt;
> &gt;
  &nbsp;
)

f=. ({.&>j),LF
t=. (2 }.each j),<'<br/>'

tohtml=: rplc & (f;"0 t)
LABCHAPTER=: 0 : 0
pc labchapter closeok;pn "Lab Chapter";
cc labid static;
cc labinfo static;cn " ";
bin hv;
minwh 240 200;cc listbox listbox;
bin zv;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin sz;
pas 4 2;pcenter;
rem form end;
)

LABCHAPTER6=: 0 : 0
pc labchapter closeok;pn "Lab Selection";
xywh 270 68 80 24;cc ok button leftmove rightmove;cn "OK";
xywh 270 98 80 24;cc cancel button leftmove rightmove;cn "Cancel";
xywh 12 70 240 200;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 14 16 332 22;cc labid static;
xywh 14 44 240 22;cc labinfo static;cn " ";
pas 4 2;pcenter;
rem form end;
)
labfmt=: 4 : 0
DEL,(":x),'. ',y,DEL
)
labchapter_run=: 3 : 0
wd IFJNET{::LABCHAPTER;LABCHAPTER6
s=. #y
wd 'set labid text *',(gettitle''),' (',(":s),(s plurals ' chapter'),')'
wd 'set labinfo text *Select a chapter:'
d=. (1+i.#y) labfmt each y
wd 'set listbox items ',;d
wd 'setfocus listbox'
wd 'pshow;'
)
labchapter=: 3 : 0
val=. dltb }.y
msk=. (<'chapter')={."1 LABDEF
if. -. 1 e. msk do.
  echo 'There are no chapters in the lab' return.
end.
if. 0=#val do.
  chp=. {:"1 msk#LABDEF
  if. IFQT do.
    labchapter_run chp
  else.
    def=. chp ,each <'''',LF
    echo }: ;'lab'':'&, each def
  end.
  return.
end.
ndx=. LABDEF i. 'chapter';val
if. 0=#ndx do.
  echo 'chapter not found: ',val
else.
  LABPOS=: ndx
  lab 0
end.
EMPTY
)
labchapter_listbox_button=: 3 : 0
ndx=. 1 + ".listbox_select
LABPOS=: ndx i.~ +/\ (<'chapter')={."1 LABDEF
wd 'pclose'
echo ''
lab 0
)
labchapter_enter=: labchapter_ok_button=: labchapter_listbox_button
labchapter_close=: labchapter_cancel=: labchapter_cancel_button=: wd bind 'pclose'
lab=: 3 : 0
if. isfilename y do. labopen y return. end.
if. LABVER=0 do. lab805 y return. end.
if. ''-:y do. labstatus'' return. end.
if. ':'={.y do. labchapter y return. end.
labjump y
)
lab805=: 3 : 0
require LAB805
if. y -: ':' do. y=. 1 end.
lab_jlab805_ y
)
labcheckdef=: 3 : 0
if. 0=#LABDEF do. 1[echo 'first open a lab' else. 0 end.
)
labcheckpos=: 3 : 0
if. LABPOS > {:LABNDX do. 1[echo 'end of lab' else. 0 end.
)
labdefs=: 3 : 0
SCRIPT=: LABFILE=: LABDEF=: ''
LABNOS=: LABNEXT=: LABNDX=: ''
LABVER=: 1
)
labhtml=: 3 : 0
if. IFJHS do.
  jhtml_jhs_ y
else.
  wd 'sm html *',y
end.
)
labhr=: 3 : 0
if. IFJHS do. jhtml_jhs_'<hr/>' else. echo 80$'_' end.
)
labjump=: 3 : 0
if. labcheckdef'' do. return. end.
if. -. isinteger y do.
  echo 'lab jumps should be 1 or 2 integers' return.
end.
if. 1=#y do.
  if. y=0 do. labnext '' return. end.
  if. y<0 do. labprev y return. end.
end.
if. 1 e. (2 < #y), (1 > y), ({.y) > #LABDEF do.
  echo 'lab jumps should be in range 1 to ',":#LABDEF return.
end.
if. 1=#y do.
  lab 0$LABPOS=: <:{.y return.
end.
'bgn end'=. y
if. end < bgn do.
  echo 'second jump should be after the first' return.
end.
end=. end <. #LABDEF
labnext1 LABNEXT=: <: bgn + i. 1 + end - bgn
)
labkey=: 3 : 0
typ=. {.y
val=. }.y
if. typ='p' do.
  runprepare val
else.
  runscript val
end.
)
lablatex=: 3 : 0
if. IFJHS do.
  jhtml_jhs_'<img src="http://latex.codecogs.com/svg.latex?',y,'" border="0"/>'
else.
  echo 'latex: ',y
end.
)
labnext=: 3 : 0
if. labcheckdef'' do. return. end.
if. labcheckpos'' do. return. end.
ind=. LABNDX i. LABPOS
while. 1 do.
  if. ind = #LABDEF do. return. end.
  'tag val'=. ind{LABDEF
  if. -. tag -: 'key' do. break. end.
  labkey val
  ind=. ind+1
end.
LABPOS=: LABPOS+1
if. (tag -: 'txt') *. 0=#val do.
  if. IFJHS do. echo ' ' else. echo ' ' end.
  labnext '' return.
end.
if. tag -: 'cmd' do. labrun val return. end.
select. tag
case. 'html' do.
  labhtml val
case. 'hr' do.
  labhr''
case. 'latex' do.
  lablatex val
case. 'chapter' do.
  echo 'Chapter: ',val
case. 'section' do.
  echo 'Chapter: ',val
case. 'txt' do.
  labtxt val
end.
labnext1''
)
labnext1=: 3 : 0
if. #LABNEXT do.
  LABPOS=: {.LABNEXT
  LABNEXT=: }.LABNEXT
  lab 0
end.
EMPTY
)
labprev=: 3 : 0
LABPOS=: 0 >. LABPOS + {.y
if. labcheckpos'' do. return. end.
lab 0
)
labrun=: 3 : 0
IMMX_jlab_=: y
9!:27 'empty labnext1_jlab_ 0!:111 IMMX_jlab_'
9!:29 [ 1
)
labstatus=: 3 : 0
if. labcheckdef'' do. return. end.
echo (":LABPOS+1),' of ',(":#LABDEF),' in ',LABFILE
)
labtxt=: 3 : 0
if. IFJHS do.
  echo y
else.
  echo y
end.
)
labopen=: 3 : 0
labdefs''
if. -. fexist y do. echo 'not found: ',y return. end.
LABVER=: getversion y
if. LABVER=0 do. lab805 y return. end.
rc=. labparse y
if. -. rc -: 0 do.
  echo rc
  labdefs'' return.
end.
LABFILE=: y
LABPOS=: 0
if. IFJHS do.
  ADVANCE_jijx_=: 'lab'
  a=. 'ctrl+. or menu > advances'
  if. 3 = nc <'labopened_jhs_' do.
    labopened_jhs_ y
  end.
elseif. IFQT do.
  a=. 'ctrl+j advances'
elseif. 1 do.
  a=. 'lab 0  NB. advances (create a shortcut key!)'
end.
echo a
labstatus''
lab 0
EMPTY
)
labparse=: 3 : 0
dat=. 'b' fread y
if. dat -: _1 do. 'not found: ',y return. end.

dat=. dtb each remcomments dat

res=. i. 0 2
nos=. i. 0
pos=. 0

while. #dat do.
  txt=. dlb 0 pick dat
  if. isnote txt do.
    'dat len'=. remnote dat
    pos=. pos + len continue.
  end.
  if. isnbkey txt do.
    'key dat len'=. getkey dat
    res=. res,'key';key
    nos=. nos, pos
    pos=. pos + len continue.
  end.
  nos=. nos, pos
  dat=. }.dat
  pos=. pos + 1
  if. 0=#txt do.
    res=. res,'txt';'' continue.
  end.
  if. t=. iscolon txt do.
    ndx=. 1 + dat i. <,')'
    if. t=1 do.
      res=. res,'cmd';toLF (<txt),ndx{.dat
    else.
      res=. res,'txt';toLF }: ndx {.dat
    end.
    dat=. ndx }. dat
    pos=. pos + ndx continue.
  end.
  if. isnblab txt do.
    ndx=. txt i. ':'
    res=. res,(6}.ndx{.txt);(ndx+1)}.txt continue.
  end.
  if. isnb txt do.
    ndx=. 0 i.~ *./\ (isnb &> dat) > isnblab &> dat
    res=. res,'txt';toLF delnb each (<txt), ndx {. dat
    dat=. ndx }. dat
    pos=. pos + ndx continue.
  end.
  res=. res,'cmd';txt
end.

LABDEF=: res
LABNOS=: nos
LABNDX=: ({.-]) +/\. (<'key') ~: {."1 LABDEF
0
)
lab_z_=: lab_jlab_
spx_z_=: lab_jlab_
