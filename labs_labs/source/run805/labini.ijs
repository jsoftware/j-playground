NB. labini.ijs    - initialize lab system
NB.
NB. main verbs:
NB.   lab          run lab (=runlab)
NB.   labinit      initialize globals for current lab
NB.   labjump      lab jump
NB.   labopen      open lab file
NB.   labreset     reset lab system
NB.   labrun       run lab section
NB.   labselect    run selection dialog
NB.
NB. other:
NB.   labline      lab line header
NB.   labposition  current position
NB.   labrun0      run bit 0 of code
NB.   labrunnext   run next bit of code
NB.   labsplit     split data into text and code
NB.   labsplitcode split code into sections
NB.   labsection     current section
NB.
NB.   ALL          all category
NB.   CMARKER      marks lab chapters
NB.   SMARKER      marks lab sections

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

IFCOMMENTS=: 1        NB. show comments
IFSENTENCES=: 1       NB. show sentences
IFWINDOWS=: 1         NB. show windows (if specified)

LABS=: ''
LABCAT=: ''
LABCATS=: ''
LABCATSEL=: 0
LABCTD=: ' (ctd)'
FONTSCALE=: 1

AUTOLAB=: 0

NB. =========================================================
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

NB. =========================================================
output=: [: empty 1!:2 & 2

NB. =========================================================
start=: 3 : 0
if. #LABS do. y labinit 1 pick LABNDX{LABS end.
empty''
)

NB. =========================================================
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

NB. =========================================================
labnext=: 3 : 0
if. #LABFILE do.
  lab 0
end.
)

NB. =========================================================
NB. labchapterline
labchapterline=: 3 : 0
if. IFCHAPTERS do.
  j=. ' Chapter ',(":1+CHAPTERNDX),' ',(CHAPTERNDX pick CHAPTERS),' '
  output LF,(2$LINE),j,(0>.LABWIDTH-2+#j)$LINE
end.
)

NB. =========================================================
labchaptername=: 3 : 0
if. 1 < #CHAPTERS do.
  (":CHAPTERNDX+1),' ',(CHAPTERNDX pick CHAPTERS),' '
else. '' end.
)

NB. =========================================================
NB. [section] labinit filename
NB.
NB. initialize lab for given file
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

NB. =========================================================
NB. labjump      - jump to chapter in lab
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

NB. =========================================================
labline=: 3 : 0
j=. ' ',labsectionname''
(2$LINE),j,' ',(0>.LABWIDTH-3+#j)$LINE
)

NB. =========================================================
NB. labopen filename
NB.
NB. open lab file, return success
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

NB. ---------------------------------------------------------
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

NB. =========================================================
NB. labopenchapter
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

NB. =========================================================
labposition=: 3 : 0
j=. (":NDX+1),' of ',":#SECTIONDATA
if. IFCHAPTERS do.
NB.  'Ch ',(":CHAPTERNDX+1),'. ',j
  '(',(":CHAPTERNDX+1),') ',j
end.
)

NB. =========================================================
NB. labrun''  - run section in lab, default NDX
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

NB. =========================================================
NB. run first time in section
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

NB. =========================================================
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

NB. this is a workaround for missing prompt on first run of lab
NB. from selection form
if. first *. #cmd do.
  cmd=. cmd,LF
end.

NB. advance indices before running code:

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

NB. =========================================================
labadvance=: 3 : 0
NDX=: >:NDX
CODE=: ''
CODENDX=: 0
)

NB. =========================================================
labsectionname=: 3 : 0
j=. '(',(labposition''),') ',;labsection''
)

onStart=: labsel_run

NB. =========================================================
NB. labselect directory
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

NB. =========================================================
labwelcome=: 3 : 0
r=. LF,'Welcome to lab: ',LABTITLE
if. 0<#LABAUTHOR do.
  r=. r,LF,LF,'Author: ',LABAUTHOR
end.
r=. r,LF,LF,ADVANCE
)

NB. =========================================================
labsection=: 3 : 0
r=. ({.SECTIONS),a:
if. 0 < NDX do.
  j=. (<:+/NDX >: SECTIONINDEX) pick SECTIONS
  k=. (-.NDX e. SECTIONINDEX)#LABCTD
  if. #j do. r=. j;k end.
end.
r
)

NB. =========================================================
NB. problem: want focus on terminal, but also
NB. viewmat windows to be shown...
labsetfocus=: 3 : 0
i.0 0
NB. if. IFIOS +: 'Android'-:UNAME do.
NB.   runimmex 'smact$0'
NB. end.
)

NB. =========================================================
NB. labsplit data
labsplit=: 3 : 0
ind=. 2+((LF,')') E. y) i. 1
}. each ind ({.;}.) y
)

NB. =========================================================
NB. labsplitcode data
labsplitcode=: 3 : 0
dat=. termLF y
,<dat;''
)
