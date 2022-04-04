coclass 'jlab805'

PATHSEP=: '/'
IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
cat=: ,&,.&.|:
commaseps=: 2 }. ;@:(', '&,&.>)
deb=: #~ (+. 1: |. (> </\))@(' '&~:)
dtb=: #~ [: +./\. ' '&~:
info=: sminfo @ ('Labs'&;)
getfontsize=: 13 : '{.1{._1 -.~ _1 ". y'
pathname=: 3 : '(b#y);(-.b=.+./\.y=PATHSEP)#y'
a=. ''''
quote=: (a&,@(,&a))@ (#~ >:@(=&a))
plurals=: ] , (1: ~: [) # 's'"_
round=: [ * [: <. 0.5"_ + %~
setlocale=: 18!:4 @ <
termLF=: , (0: < #) # LF"_ -. _1&{.
termdelLF=: }.~ [: - 0: i.~ LF&= @ |.
tolist=: ; @: (DEL&, each) @: (,&DEL each)
wdifopen=: boxopen e. ({."1 @: wdforms)
assert=: 3 : 0
'' assert y
:
if. -. 0 e. y do. return. end.
msg=. x
if. 0=#msg do.
  j=. 'There is a problem with the lab.',LF,LF
  msg=. j,'Try re-loading J and starting it again.'
end.
info msg
laberror=. 13!:8@1:
laberror''
)
checkdepends=: 3 : 0
if. 0 = #r=. checkdepends1 '' do. 1 return. end.
0[smoutput LF,r
)
checkdepends1=: 3 : 0
fls=. getscripts_j_ LABDEPENDS
if. 0=#fls do. '' return. end.
add=. jpath '~addons/'
if. 1 e. b=. (<add) ~: (#add) {.each fls do.
  'Lab dependency not an addon: ',commaseps b#fls return.
end.
if. -. 1 e. b=. -. fexist &> fls do. '' return. end.
fls=. (#add) }. each b#fls
fls=. ({.~ 2 i.~ '/' +/\ .= ]) each fls
'To run this lab, first install: ',commaseps fls
)
dtree=: 3 : 0
p=. y #~ (+./\ *. +./\.) y~:' '
p=. jpath p,'/' -. {:p
d=. 1!:0 p,'*'
if. 0 = #d do. '' return. end.
d=. d #~ 'h' ~: 1 {"1 > 4 {"1 d
if. 0 = #d do. '' return. end.
m=. 'd' = 4 {"1 > 4 {"1 d
d=. (<p) ,each {."1 d
((-.m) # d), ;dtree each m # d
)
excludes=: 3 : 0
t=. 'b' fread '~addons/labs/labs/exlabs.txt'
if. t-:_1 do. y return. end.
t=. t #~ '#' ~: {.&> t
0!:100 ; t ,each LF
r=. EXALL
if. IFJHS do.
  r=. r,EXJHS
elseif. IFQT do.
  r=. r,EXJQT
elseif. IFJNET do.
  r=. r,EXJNET
end.
r=. ((jpath '~addons/'),deb) each <;._2 r
y #~ -. (2{"1 y) e. r
)
pdef=: 3 : 0
if. 0 e. $y do. empty'' return. end.
names=. {."1 y
if. #names do. (names)=: {:"1 y end.
names
:
names=. {."1 y
nl=. ;: ::] x
pdef (names e. nl)#y
)
runimmex=: 3 : 0
IMMEX=: y
9!:27 '0!:100 IMMEX_jlab805_'
9!:29 [ 1
)
run1=: 3 : 0
setlocale 'base'
0!:111 y [ 4!:55<'y'
)
runquiet=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<":x) ndx } txt
)
trimLF=: 3 : 0
y #~ (+./\ *. +./\.) LF~:y
)
wraptext=: 3 : 0
if. LABWIDTH > #y do. y return. end.
if. LABWRAP do.
  (LABWIDTH foldtext _2}. y) , _2{.y
else.
  y
end.
)
f=. 3 : 'labnext_jlab805_ :: ] '''''
plot_jctrl_fkey_jwplot_=: f f.
jvm_jctrl_fkey_jviewmat_=: f f.
graph_jctrl_fkey_jzgraph_=: f f.
labaddons=: 3 : 0
ADDLABS=: ''
p=. jpath '~addons/'
0!:0 :: ] <jpath p,'config/config.ijs'
if. #ADDLABS do.
  nms=. <;._1 &> ' ' ,each <;._2 jpathsep ADDLABS
  fls=. (<p) ,each {."1 nms
  msk=. fexist &> fls
  fls=. msk # fls
  nms=. msk # nms
  cat=. {:"1 nms
  tit=. labgettitle1 each fls
  msk=. 0 < # &> tit
  ADDLABS=: msk#cat,.tit,.fls,.<0
else.
  ADDLABS=: i.0 4
end.
fls=. fls #~ (<'.ijt') = _4 {.each fls=. dtree p
fls=. fls -. 2 {"1 ADDLABS
if. #fls do.
  cat=. '/' taketo each (#p) }. each fls
  tit=. labgettitle1 each fls
  msk=. 0 < # &> tit
  ADDLABS=: ADDLABS,msk#cat,.tit,.fls,.<0
end.
EMPTY
)
labgetsubdir=: 3 : 0
t=. 1!:0 y,'*'
b=. 'd' = 4{ &> 4{"1 t
{."1 b # t
)
labdir=: 3 : 0
fl=. jpath '~config/labdir.ijs'
if. 0 = fexist fl do.
  fl=. LABDIRECTORY,'labdir.ijs'
end.
0!:0 <fl
n=. '_ '&charsub each {."1 LABDIR
d=. {:"1 LABDIR
LABDIR=: (~:d) # n,.d
)
labdir1=: 3 : 0
t=. 1!:0 y,'*'
d=. 'd' = 4{ &> 4{"1 t
t=. tolower each {."1 d#t
n=. ((toupper)@{. , }.) each t
t=. n ,. (y&,) each t
b=. 0 < # @ (1!:0) @ (,&'\*.ijt') &> {:"1 t
b # t
)
labgetfiles=: 3 : 0
if. #y do.
  path=. y,PATHSEP -. {:y
  j=. labgetjt path
  if. 0=#j do.
    info 'No tutorials found in: ',":y
    labreset''
    return.
  end.
  dname=. 1 pick pathname }:path
  LABDIR=: 1 2$dname;path
else.
  labdir''
  j=. ; < @ ({. ,. labgettutor &> @ {:)"1 LABDIR
  j=. ~. j,ADDLABS
end.
j=. excludes j
j=. (~: 1 {"1 j) # j
LABS=: j sort > 1{"1 j
)
labgettutor=: labgetjt
labgetjt=: 3 : 0
path=. y, PATHSEP -. _1{.y
files=. 1 dir jpathsep path,'*.ijt'

if. 0=#files do.
  t=. i.0 3
else.
  sf=. 1 dir jpathsep path,'*.ijf'
  if. #sf do.
    j=. _4&}. each sf
    k=. _4&}. each files
    s=. k e. j
  else.
    s=. (#files)#0
  end.
  t=. labgettitle1 each files
  m=. 0 < # &> t
  t=. m # t,. files (,<)"0 [s
end.

if. #s=. labgetsubdir path do.
  t=. t, ; labgetjt each path&, each s
end.

)
labgettitle1=: 3 : 0
dat=. <;._2 LF,~ 1000 {. freads y
dat=. deb 0 pick dat -. a:
if. 'LABTITLE' -: 8 {. dat do.
  ". dat
elseif. 'NB. Lab:' -: 8 {. dat do.
  deb 8 }. dat
elseif. do. ''
end.
)
ADVANCE=: 0 : 0
To advance the lab, select menu Help|Studio|Advance or the
corresponding shortcut.
)

ALL=: '(All)'
LABDIRECTORY=: jpath '~addons/labs/labs/'
ADDONSDIRECTORY=: }: jpath '~addons/a'
CMARKER=: 'Lab Chapter'
RXCMARKER=: '\\par [\\[:alnum:]* ]*',CMARKER
SMARKER=: 'Lab Section'
RXSMARKER=: '\\par [\\[:alnum:]* ]*',SMARKER
RXPAREN=: '\\par [\\[:alnum:]* ]*)'

IFCOMMENTS=: 1
IFSENTENCES=: 1
IFWINDOWS=: 1

LABS=: ''
LABCAT=: ''
LABCATS=: ''
LABCATSEL=: 0
LABCTD=: ' (ctd)'
FONTSCALE=: 1

AUTOLAB=: 0
labreset=: 3 : 0
LABAUTHOR=: ''
LABCOMMENTS=: ''
LABDEPENDS=: ''
LABTITLE=: ''
LABWINPOS=: _1
LABOUTPUT=: 1
LABWIDTH=: (IFIOS+.'Android'-:UNAME){61 48
LABFILE=: ''
LABPATH=: jpath '~addons/labs/labs/'

LINE=: 1{,":<' '

CHAPTERDATA=: ,a:
CHAPTERNDX=: 0
CHAPTERS=: ,a:

CODE=: ''
CODENDX=: 0
SECTIONDATA=: ,a:
NDX=: 0
SECTIONINDEX=: 0
SECTIONS=: ,a:

IFCHAPTERS=: 0
IFNEWSECTION=: 0
LABWRAP=: 1
ENDOFLAB=: 0

empty''
)
output=: [: empty 1!:2 & 2
start=: 3 : 0
if. #LABS do. y labinit 1 pick LABNDX{LABS end.
empty''
)
lab=: 3 : 0
if. 1=L.y do.
  'file ndx'=. y
  ndx labinit file
elseif. 0 e. $y do.
  labselect''
elseif. 0 = {.y do.
  labrun }.y
elseif. y-:_1 do.
  labrun y
elseif. y-:1 do.
  labjump''
elseif. y-:3 do.
  labopt_run''
elseif. 2=3!:0 y do.
  labinit y
end.
empty''
)
labnext=: 3 : 0
if. #LABFILE do.
  lab 0
end.
)
labchapterline=: 3 : 0
if. IFCHAPTERS do.
  j=. ' Chapter ',(":1+CHAPTERNDX),' ',(CHAPTERNDX pick CHAPTERS),' '
  output LF,(2$LINE),j,(0>.LABWIDTH-2+#j)$LINE
end.
)
labchaptername=: 3 : 0
if. 1 < #CHAPTERS do.
  (":CHAPTERNDX+1),' ',(CHAPTERNDX pick CHAPTERS),' '
else. '' end.
)
labinit=: 3 : 0
0 labinit y
:
if. 0=labopen y do. return. end.
if. x=0 do.
  dat=. 'Lab: ',LABTITLE,LF
  dat=. dat, (*#LABAUTHOR) # 'Author: ',LABAUTHOR,LF
  dat=. (LABWIDTH#LINE),LF,dat,ADVANCE
  output dat
  labchapterline''
  labrun x
end.
)
labjump=: 3 : 0
if. 0=#LABFILE do. info 'no lab selected' return. end.

if. NDX=0 do.
  if. 0=#LABFILE do.
    info 'no lab selected' return.
  end.
  0 labinit LABPATH,LABFILE
end.

if. 0=#y do.
  labjump_run''
else.
  labchapter y
end.
)
labline=: 3 : 0
j=. ' ',labsectionname''
(2$LINE),j,' ',(0>.LABWIDTH-3+#j)$LINE
)
labopen=: 3 : 0
labreset''
f=. fboxname y
dat=. fread f
if. dat-:_1 do.
  info 'not found: ',":>y
  0 return.
end.

'LABPATH LABFILE'=: pathname >f
IFCHAPTERS=: 1 e. CMARKER E. dat
dat=. toJ dat
dat=. dat,LF -. {:dat
dat=. <;.2 dat
dat=. ;dat #~ -. 'NB. =='&-: @ (6&{.) &> dat

if. IFCHAPTERS do.
  cut=. }:(LF,CMARKER) E. LF,dat
  0!:100 (cut i. 1){.dat
  dat=. cut <;.1 dat
  ind=. dat i.&> LF
  CHAPTERS=: (>:#CMARKER) }.each ind {.each dat
  CHAPTERDATA=: ind }. each dat
else.
  cut=. }:(LF,SMARKER) E. LF,dat
  0!:100 (cut i. 1){.dat
  CHAPTERS=: ,a:
  CHAPTERDATA=: <(cut i. 1)}.dat
end.

if. -. checkdepends'' do. 0 return. end.

if. LABOUTPUT *. IFCOMMENTS do.
  output=: [: empty 1!:2 & 2
else.
  output=: ]
end.

labopenchapter 0
)
labopenchapter=: 3 : 0
CHAPTERNDX=: y
if. IFCHAPTERS do.
  WINTITLE=: LABTITLE,' - ',y pick CHAPTERS
else.
  WINTITLE=: LABTITLE
end.
dat=. y pick CHAPTERDATA
if. #dat do.
  cut=. }:(LF,SMARKER) E. LF,dat
  dat=. cut <;.1 dat
  ind=. dat i.&> LF
  top=. (>:#SMARKER) }.each ind {.each dat
  NDX=: 0
  SECTIONDATA=: ind }. each dat
  SECTIONINDEX=: I. 0< # &> top
  SECTIONS=: SECTIONINDEX { top
else.
  SECTIONDATA=: ,a:
  SECTIONINDEX=: 0
  SECTIONS=: ,a:
end.
NDX=: 0
CODENDX=: 0
CODE=: ''
1
)
labposition=: 3 : 0
j=. (":NDX+1),' of ',":#SECTIONDATA
if. IFCHAPTERS do.
  '(',(":CHAPTERNDX+1),') ',j
end.
)
labrun=: 3 : 0
if. 0=#LABFILE do. info 'no lab selected' return. end.

if. #y do.
  if. y e. i.#SECTIONDATA do.
    NDX=: {. y
    CODENDX=: 0
    CODE=: ''
  elseif. y=_1 do.
    NDX=: CODENDX=: 0
  elseif. do.
    info 'Invalid jump section'
    return.
  end.
end.

if. NDX >: #SECTIONDATA do.
  if. CHAPTERNDX >: <: #CHAPTERS do.
    ENDOFLAB=: 1
    (LF,'End of lab') 1!:2 [ 2 return.
  else.
    labopenchapter CHAPTERNDX+1
    labchapterline''
  end.
end.

if. CODENDX < #CODE do. labruncode'' return. end.
dat=. NDX pick SECTIONDATA
labrun0 dat
)
labrun0=: 3 : 0
'txt dat'=. labsplit y

section=. labline''
txt=. LF, (0<#txt) # wraptext txt
output LF,section,txt

cmd=. trimLF dat

while. 1 do.
  if. 'PREPARE' -: 7{.cmd do.
    cmd=. }. <;.2 cmd,LF
    ndx=. 1 i.~ 'PREPARE'&-: @ (7&{.) &> cmd
    prep=. ;ndx{.cmd
    cmd=. trimLF ;(ndx+1)}.cmd
    runquiet prep
    continue.
  elseif. 'SCRIPT' -: 6{.cmd do.
    cmd=. }. <;.2 cmd,LF
    ndx=. 1 i.~ 'SCRIPT'&-: @ (6&{.) &> cmd
    SCRIPT=: ;ndx{.cmd
    cmd=. trimLF ;(ndx+1)}.cmd
    continue.
  end.
  break.
end.

CODE=: labsplitcode cmd
CODENDX=: 0

labruncode''
)
labruncode=: 3 : 0

if. 0=#CODE do.
  labadvance''
  labsetfocus''
  return.
end.
if. IFSENTENCES=0 do.
  labadvance''
  labsetfocus''
  return.
end.

first=. 0=NDX+CHAPTERNDX+CODENDX

'cmd snd'=. CODENDX pick CODE
CODENDX=: >:CODENDX
if. first *. #cmd do.
  cmd=. cmd,LF
end.
if. CODENDX < #CODE do.
  outtxt=. LF,(3#LINE),' more ',(7#LINE),LF
else.
  outtxt=. i.0 0
  labadvance''
end.

if. (1 e. cmd ~: LF) *. 2 = 3!:0 cmd do.
  run1 cmd
end.

output outtxt
labsetfocus''
)
labadvance=: 3 : 0
NDX=: >:NDX
CODE=: ''
CODENDX=: 0
)
labsectionname=: 3 : 0
j=. '(',(labposition''),') ',;labsection''
)

onStart=: labsel_run
labselect=: 3 : 0
labaddons''
labgetfiles y
j=. sort ~. {."1 LABS
if. 1=#j do.
  LABCATS=: LABCAT=: j
else.
  LABCATS=: ALL;j
  if. (0=#LABCAT) +. -. LABCAT e. LABCATS do.
    LABCAT=: <ALL
  end.
end.
labsel_run`wd@.IFJA 'activity ',>coname''
)
labwelcome=: 3 : 0
r=. LF,'Welcome to lab: ',LABTITLE
if. 0<#LABAUTHOR do.
  r=. r,LF,LF,'Author: ',LABAUTHOR
end.
r=. r,LF,LF,ADVANCE
)
labsection=: 3 : 0
r=. ({.SECTIONS),a:
if. 0 < NDX do.
  j=. (<:+/NDX >: SECTIONINDEX) pick SECTIONS
  k=. (-.NDX e. SECTIONINDEX)#LABCTD
  if. #j do. r=. j;k end.
end.
r
)
labsetfocus=: 3 : 0
i.0 0
)
labsplit=: 3 : 0
ind=. 2+((LF,')') E. y) i. 1
}. each ind ({.;}.) y
)
labsplitcode=: 3 : 0
dat=. termLF y
,<dat;''
)
LABJUMP=: 0 : 0
pc labjump closeok;pn "Lab Selection";
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

LABJUMP6=: 0 : 0
pc labjump closeok;pn "Lab Selection";
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
labjump_run=: 3 : 0
if. 1=#CHAPTERDATA do.
  info 'There is only one chapter in the lab'
  return.
end.
wd IFJNET{::LABJUMP;LABJUMP6
s=. #CHAPTERS
wd 'set labid text *',LABTITLE,' (',(":s),(s plurals ' chapter'),')'
wd 'set labinfo text *Select a chapter:'
d=. (1+i.#CHAPTERS) labfmt each CHAPTERS
wd 'set listbox items ',;d
wd 'setselect listbox ',":CHAPTERNDX
wd 'setfocus listbox'
wd 'pshow;'
)
labchapter=: 3 : 0
labopenchapter <: 1 >. y <. #CHAPTERS
labchapterline''
lab 0
)
labjump_listbox_button=: 3 : 0
labopenchapter ".listbox_select
labchapterline''
wd 'pclose'
labrun''
)
labjump_enter=: labjump_ok_button=: labjump_listbox_button
labjump_close=: labjump_cancel=: labjump_cancel_button=: wd bind 'pclose'
LABOPT=: 0 : 0
pc labopt;pn "Lab Options";
bin vh;
groupbox "Lab Displays";
cc comments checkbox;cn "Comment text";
cc sentences checkbox group;cn "J sentences";
groupboxend;
bin v;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin szzsz;
pas 6 6;pcenter;
rem form end;
)

LABOPT6=: 0 : 0
pc labopt;pn "Lab Options";
xywh 18 18 226 78;cc g0 groupbox;cn "Lab Displays";
xywh 36 42 152 22;cc comments checkbox;cn "Comment text";
xywh 36 66 152 22;cc sentences checkbox group;cn "J sentences";
xywh 272 18 80 24;cc ok button;cn "OK";
xywh 272 48 80 24;cc cancel button;cn "Cancel";
pas 6 6;pcenter;
rem form end;
)
labopt_run=: 3 : 0
wd IFJNET{::LABOPT;LABOPT6
wd 'set comments value ',":IFCOMMENTS
wd 'set sentences value ',":IFSENTENCES
wd 'pshow;'
)
labopt_close=: 3 : 0
IFCOMMENTS=: 0 ". comments
IFSENTENCES=: 0 ". sentences
if. LABOUTPUT *. IFCOMMENTS do.
  output=: [: empty 1!:2 & 2
else.
  output=: ]
end.
wd 'pclose'
)
labopt_cancel=: labopt_cancel_button=: wd bind 'pclose'
labopt_ok_button=: labopt_enter=: labopt_close
LABSEL=: 0 : 0
pc labsel closeok;pn "Lab Select";
menupop "Options";
menu comments "Labs display &Comment Text" "" "" "Show comments when running Labs";
menu sentences "Labs display J &Sentences" "" "" "Show sentences when running Labs";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu intro "&Introduction to Labs..." "" "" "";
menupopz;
groupbox "";
bin h;
cc s0 static;cn "Select a lab";
bin s;
cc browse button;cn "&Browse...";
bin z;
groupboxend;
groupbox "";
bin hvh;
cc s1 static;cn "Category:";
cc category combolist;
set category stretch 9;
bin z;
minwh 296 314;cc listbox listbox;
bin z;
bin v;
cc ok button;cn "&Run";
cc print button;cn "&Print";
bin s;
cc cancel button;cn "&Close";
bin z;
bin z;
groupboxend;
pas 6 4;pcenter;
rem form end;
)

LABSEL6=: 0 : 0
pc8j labsel closeok;pn "Lab Select";
menupop "Options";
menu comments "Labs display &Comment Text" "" "" "Show comments when running Labs";
menu sentences "Labs display J &Sentences" "" "" "Show sentences when running Labs";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu intro "&Introduction to Labs..." "" "" "";
menupopz;
xywh 22 24 248 22;cc s0 static;cn "Select a lab";
xywh 14 6 422 46;cc g0 groupbox rightmove;cn "";
xywh 326 22 100 24;cc browse button leftmove rightmove;cn "&Browse...";
xywh 22 78 74 22;cc s1 static;cn "Category:";
xywh 100 76 214 218;cc category combodrop ws_vscroll rightmove;
xywh 22 110 292 314;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 326 112 100 24;cc ok button leftmove rightmove;cn "&Run";
xywh 326 142 100 24;cc print button leftmove rightmove;cn "&Print";
xywh 326 388 100 24;cc cancel button leftmove topmove rightmove bottommove;cn "&Close";
xywh 14 58 422 366;cc g1 groupbox rightmove bottommove;cn "";
pas 6 4;pcenter;
rem form end;
)

LABSELJA=: 0 : 0
pc labsel closeok;pn "Lab Select";
bin v;
cc s0 static;cn "Select a lab";
cc s1 static;cn "Category:";
wh _1 _2;cc category combolist;
wwh 1 _1 0;cc listbox listbox;
bin z;
pas 6 4;pcenter;
rem form end;
)
labsel_run=: 3 : 0
if. wdisparent 'labsel' do.
  wd 'psel labsel;pshow;pactive' return.
end.
wd IFJA{::(IFJNET{::LABSEL;LABSEL6);LABSELJA
labshowcats''
if. IFJA do.
  labsel_listbox_select=: labsel_listbox_button
else.
  wd 'set comments checked ',":IFCOMMENTS
  wd 'set sentences checked ',":IFSENTENCES
  wd 'setfocus listbox'
  wdfit''
end.
wd 'pshow;'
)
labsel_browse_button=: 3 : 0
p=. jpath '~user'
j=. '"Labs (*.ijt)|*.ijt|All Files (*.*)|*.*"'
if. IFJNET do.
  f=. mbopen '"Open File" "',p,'" "" ',j
else.
  f=. wd 'mb open1 "Open File" "',p,'" ',j
end.
if. #f do.
  labselrun f
end.
)
labsel_listbox_button=: 3 : 0
if. #listbox do.
  labselrun 2 pick (".listbox_select) { LABCATSEL#LABS
end.
)
labsel_print_button=: 3 : 0
if. #listbox do.
  if. IFJNET do.
    printfiles_j_ 2 pick (".listbox_select) { LABCATSEL#LABS
  else.
    wd 'mb print ', 2 pick (".listbox_select) { LABCATSEL#LABS
  end.
end.
)
labsel_enter=: labsel_ok_button=: labsel_listbox_button
labsel_intro_button=: labselrun bind (jpath '~addons/labs/labs/labintro.txt')
labselrun=: 3 : 0
lab_jlab_ y
wd :: ] 'psel labsel;pclose;'
smact`smselact_jijs_@.IFJNET''
)
labsel_cancel_button=: wd bind 'pclose'
labsel_exit_button=: labsel_cancel_button
labsel_category_button=: 3 : 0
if. LABCAT -: <category do. return. end.
LABCAT=: <category
labshowcats''
)
labsel_comments_button=: 3 : 0
IFCOMMENTS=: -. IFCOMMENTS
wd 'set comments checked ',":IFCOMMENTS
)
labsel_sentences_button=: 3 : 0
IFSENTENCES=: -. IFSENTENCES
wd 'set sentences checked ',":IFSENTENCES
)
labshowcats=: 3 : 0
if. LABCAT -: <ALL do.
  LABCATSEL=: 1 #~ #LABS
else.
  LABCATSEL=: ({."1 LABS) e. LABCAT
end.
labshowall''
)
labsel_category_select=: labsel_category_button
labshowall=: 3 : 0
if. -. (<'labsel') e. {."1 wdforms'' do. return. end.
wd 'set category items ', tolist LABCATS
wd 'setselect category ',":LABCATS i. LABCAT
d=. LABCATSEL # LABS
wd 'set listbox items ', tolist 1{"1 d
wd 'setselect listbox 0'
)

labreset ''
