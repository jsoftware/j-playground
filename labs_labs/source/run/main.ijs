NB. main

NB. =========================================================
lab=: 3 : 0
if. isfilename y do. labopen y return. end.
if. LABVER=0 do. lab805 y return. end.
if. ''-:y do. labstatus'' return. end.
if. ':'={.y do. labchapter y return. end.
labjump y
)

NB. =========================================================
lab805=: 3 : 0
require LAB805
if. y -: ':' do. y=. 1 end.
lab_jlab805_ y
)

NB. =========================================================
NB. return 0=ok, 1=fail
labcheckdef=: 3 : 0
if. 0=#LABDEF do. 1[echo 'first open a lab' else. 0 end.
)

NB. =========================================================
NB. return 0=ok, 1=fail
labcheckpos=: 3 : 0
if. LABPOS > {:LABNDX do. 1[echo 'end of lab' else. 0 end.
)

NB. =========================================================
labdefs=: 3 : 0
SCRIPT=: LABFILE=: LABDEF=: ''
LABNOS=: LABNEXT=: LABNDX=: ''
LABVER=: 1
)

NB. =========================================================
labhtml=: 3 : 0
if. IFJHS do.
  jhtml_jhs_ y
else.
  wd 'sm html *',y
end.
)

NB. =========================================================
labhr=: 3 : 0
if. IFJHS do. jhtml_jhs_'<hr/>' else. echo 80$'_' end.
)

NB. =========================================================
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

NB. =========================================================
NB. keyword
labkey=: 3 : 0
typ=. {.y
val=. }.y
if. typ='p' do.
  runprepare val
else.
  runscript val
end.
)

NB. =========================================================
lablatex=: 3 : 0
if. IFJHS do.
  jhtml_jhs_'<img src="http://latex.codecogs.com/svg.latex?',y,'" border="0"/>'
else.
  echo 'latex: ',y
end.
)

NB. =========================================================
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

NB. =========================================================
labnext1=: 3 : 0
if. #LABNEXT do.
  LABPOS=: {.LABNEXT
  LABNEXT=: }.LABNEXT
  lab 0
end.
EMPTY
)

NB. =========================================================
labprev=: 3 : 0
LABPOS=: 0 >. LABPOS + {.y
if. labcheckpos'' do. return. end.
lab 0
)

NB. =========================================================
labrun=: 3 : 0
IMMX_jlab_=: y
NB. 9!:27 'labnext1_jlab_ 0!:111 IMMX_jlab_'
9!:27 'empty labnext1_jlab_ 0!:111 IMMX_jlab_'
9!:29 [ 1
)

NB. =========================================================
labstatus=: 3 : 0
if. labcheckdef'' do. return. end.
echo (":LABPOS+1),' of ',(":#LABDEF),' in ',LABFILE
)

NB. =========================================================
labtxt=: 3 : 0
if. IFJHS do.
  echo y
else.
  echo y
NB.   wd 'sm html *<html><span style="color:red">',(tohtml y),'</span></html>'
end.
)