NB. labutil

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
termLF=: , (0: < #) # LF"_ -. _1&{.    NB. ensure LF terminated
termdelLF=: }.~ [: - 0: i.~ LF&= @ |.  NB. ensure not LF terminated
tolist=: ; @: (DEL&, each) @: (,&DEL each)
wdifopen=: boxopen e. ({."1 @: wdforms)

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
info msg
laberror=. 13!:8@1:
laberror''
)

NB. =========================================================
checkdepends=: 3 : 0
if. 0 = #r=. checkdepends1 '' do. 1 return. end.
0[smoutput LF,r
)

NB. =========================================================
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

NB. =========================================================
NB.*dtree v get filenames in directory tree
NB. return list of filenames in directory tree
NB. y is a folder name (with or without trailing separator)
NB. hidden files and directories are ignored
NB. result has full pathnames
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

NB. =========================================================
NB. excludes
NB. ignore labs in exclude lists
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

NB. =========================================================
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

NB. =========================================================
runimmex=: 3 : 0
IMMEX=: y
9!:27 '0!:100 IMMEX_jlab_'
9!:29 [ 1
)

NB. =========================================================
run1=: 3 : 0
setlocale 'base'
0!:111 y [ 4!:55<'y'
)

NB. =========================================================
runquiet=: 3 : 0
setlocale 'base'
0!:100 y [ 4!:55<'y'
)

NB. =========================================================
NB. setfontsize
NB. size setfontsize fontdescription
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<":x) ndx } txt
)

NB. =========================================================
trimLF=: 3 : 0
y #~ (+./\ *. +./\.) LF~:y
)

NB. =========================================================
NB. wraptext
NB. wrap text in jx window
wraptext=: 3 : 0
if. LABWIDTH > #y do. y return. end.
if. LABWRAP do.
  (LABWIDTH foldtext _2}. y) , _2{.y
else.
  y
end.
)

NB. =========================================================
NB. function keys for common applications:
f=. 3 : 'labnext_jlab_ :: ] '''''
plot_jctrl_fkey_jwplot_=: f f.
jvm_jctrl_fkey_jviewmat_=: f f.
graph_jctrl_fkey_jzgraph_=: f f.
