NB. util

isinteger=: (-: <.) ::0:
matches=: <@[ = #@[ {.each ]
plurals=: ] , (1: ~: [) # 's'"_
setlocale=: 18!:4 @ <
toLF=: }. @ ; @: (LF&, each)

NB. =========================================================
NB. assert
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

NB. =========================================================
delnb=: 3 : 0
y }.~ 3 + 'NB. ' -: 4 {. y
)

NB. =========================================================
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

NB. =========================================================
gettitle=: 3 : 0
txt=. (<0;1) {:: LABDEF
if. 'Lab:' -: 4 {.txt do.
  deb 4 }. txt
else.
  LABFILE
end.
)

NB. =========================================================
NB. getversion 0=pre-806, 1=806
getversion=: 3 : 0
dat=. a: -.~ 'b' fread y
if. 0=#dat do. 1 return. end.
a=. 'LABTITLE=:' -: 10 {. (0 pick dat) -. ' '
b=. (<'Lab Section') e. 11 {.each dat
a +: b
)

NB. =========================================================
NB. returns 0=no, 1=not lab text, 2=lab text
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

NB. =========================================================
NB. check if filename argument (no test for exist)
isfilename=: 3 : 0
*./ (2=3!:0 y),(0<#y),':'~:{.y
)

NB. =========================================================
isnb=: 3 : 0
'NB.'-:3{.dlb y
)

NB. =========================================================
NB. is a prepare or script keyword
isnbkey=: 3 : 0
('NB.labprepare:'-:14 {. y) +. ('NB.labscript:'-:13 {. y)
)

NB. =========================================================
NB. is a note
isnote=: 3 : 0
'Note ' -: 5 {. y
)

NB. =========================================================
NB. allow both lab and spx tags:
isnblab=: 3 : 0
('NB.lab'-:6{.y) +. 'NB.spx'-:6{.y
)

NB. =========================================================
NB. remove 1-line comments
remcomments=: 3 : 0
dat=. dlb each y
msk=. (<'NB.') = 3 {.each dat
bal=. (' ' -.~ 3 }. ]) each msk#dat
bal=. (2 < +/@(*./\)@(e.&'-=')) &> bal
y #~ -. msk expand bal
)

NB. =========================================================
NB. remove note
remnote=: 3 : 0
len=. 1 + y i. <,')'
(len }. y);len
)

NB. =========================================================
runprepare=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)

NB. =========================================================
runscript=: 3 : 0
SCRIPT=: SCRIPT, y,LF
)


NB. =========================================================
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
