NB. startup J code for the j playground
NB. make changes in the playground source directory and rebuild

Displayload_j_=: 0
SystemFolders_j_=: |: ('temp';'') ,. ('addons';'/addons/')

load 'jlibrary/system/util/scripts.ijs'
load 'jlibrary/system/util/pacman.ijs'

IFTESTPLOTJHS_z_=: 1

IFJHS_jzplot_=: 1
IFPLAY_jviewmat_=: 1

getJS_j_=: {{)n
var html = jgetstr("playhtml_j_");
tcmreturn(html);
}}

canvasnum_jws_=: 0
Ignore_j_=: ~.'jhs';Ignore_j_

boxdraw_j_ 0
NB. util

cocurrent 'z'

Aqua=: 0 255 255
Black=: 0 0 0
Blue=: 0 0 255
Fuchsia=: 255 0 255
Gray=: 128 128 128
Green=: 0 128 0
Lime=: 0 255 0
Maroon=: 128 0 0
Navy=: 0 0 128
Olive=: 128 128 0
Purple=: 128 0 128
Red=: 255 0 0
Silver=: 192 192 192
Teal=: 0 128 128
White=: 255 255 255
Yellow=: 255 255 0

NB. =========================================================
NB. convert strings with J box chars to utf8
NB. rank < 2
boxj2utf8=: 3 : 0
if. 1 < #$y do. y return. end.
b=. (16+i.11) { a.
if. -. 1 e. b e. y do. y return. end.
y=. ucp y
a=. ucp '┌┬┐├┼┤└┴┘│─'
x=. I. y e. b
utf8 (a {~ b i. x { y) x } y
)

NB. =========================================================
NB. opens a file in the j playground editor
open=: 3 : 0
data =. fread getscripts_j_ y
(2!:0) 'if (confirm("Are you sure you wish to overwrite the editor?")) { ecmset(jgetstr("data")) }'
)

NB. =========================================================
plotcanvas=: 3 : 0
d=. fread '~temp/plot.html'
canvasnum_jws_=: >:canvasnum_jws_
canvasname=. 'canvas',":canvasnum_jws_
c=. canvasname,' ',":CANVAS_DEFSIZE_jzplot_
d=. (('function graph()'E.d)i.1)}.d
d=. (('</script>'E.d)i.1){.d
d=. d,'graph();'
d=. d rplc'canvas1';canvasname
playhtml_j_=: '7',c,LF,d
(2!:0) getJS_j_
)

NB. =========================================================
plotdef=: 3 : 0
'CANVAS_DEFSHOW_jzplot_ CANVAS_DEFWINDOW_jzplot_ CANVAS_DEFSIZE_jzplot_ JHSOUTPUT_jzplot_'=: y
JHSOUTPUT_jzplot_=: 'canvas'
i.0 0
)

NB. =========================================================
BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)
NB. ===================================================
NB. support for pacman (WIP)

cocurrent 'jpacman'

httpgetJS =: {{)n
    let url = jgetstr("URL_httpget_");
    var request = new XMLHttpRequest();
    request.open('GET', url, false);
    request.send(null);
    console.log(url);
    if (request.status === 200) {
      //console.log(request.responseText);
      //this fails on a large file
      //jsetstr("RESPONSE_httpget_",request.responseText);

      //from https://github.com/emscripten-core/emscripten/issues/6860
      var bufferSize = Module.lengthBytesUTF8(request.responseText);
      var bufferPtr = Module._malloc(bufferSize + 1);
      Module.stringToUTF8(request.responseText, bufferPtr, bufferSize + 1);

      jsetstrPtr("RESPONSE_httpget_",bufferPtr);
    }


}}

getfileurl=: 3 : 0
'tag rep cmt file'=. y
select. tag
case. 'github' do.
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  sub=. ;2 }. p
  'https://raw.githubusercontent.com/',rpo,cmt,'/',sub,file
case. do.
  ''
end.
)

NB. extracts a path from a path with filename
getPath =: 3 : 0
'/' , y #~ +./\. y e. '=/'
)

readpackage =: 3 : 0

'tag rep cmt'=: y

NB. execute the manifest to get the FILES list
(0!:100) <'manifest.ijs'

NB. make the folder for the addon
mkdir (jpath '~addons/',FOLDER)

filesBoxed =. LF cut FILES
urls =. getfileurl each {{tag;rep;cmt;(y,LF)}} each filesBoxed
outputPaths =. {{jpath '~addons/',FOLDER,'/',y}} each filesBoxed
cmds =. urls,.(<"0 (#urls)#100),.outputPaths

NB. make any subdirectories
mkdir_jpacman_ each ~. getPath each outputPaths

NB. download each file
httpget each <"1 cmds
)

httpget =: 3 : 0
'f t p'=. 3 {. (boxxopen y),a:
URL_httpget_ =: f
(2!:0) httpgetJS
n=. f #~ -. +./\. f e. '=/'
if. 0=#p do. p=. jpath '~temp/',n end.
RESPONSE_httpget_ (1!:2) <p
0;n
)

NB. override install to only support github for now
install_z_ =: 3 : 0
  install_gitrepo_jpacman_ y
)

NB. create a helper httpget in z
httpget_z_ =: 3 : 0
  httpget_jpacman_ y
)
cocurrent 'jws'

ContextHelp=: ,'j'
ContextTarget=: 'nuvoc'
NB. help

NB. =========================================================
helpcontext=: 3 : 0
ContextTarget=: 'dict'
helpcontext_do y
)

NB. =========================================================
helpcontext1=: 3 : 0
ContextTarget=: 'nuvoc'
helpcontext_do y
)

NB. =========================================================
helpcontext_do=: 3 : 0
ndx=. 2 { I. ' ' = 40 {. y
'class bgn end'=. 0 ". ndx {. y
txt=. (ndx+1) }. y
if. end > bgn do.
  sel=. (1+end-bgn) {. bgn }. txt
else.
  sel=. helppos class;bgn;txt,LF
end.
if. 0=#sel do. '' return. end.
helpsel sel
)

NB. =========================================================
NB. return help topic ndx from primitive
helpndx=: 3 : 0
y=. ,y
if. 2 = 3!:0 y do.
  if. 'goto_' -: 5{.y do. y=. 'goto_?'
  elseif. 'for_' -: 4{.y do. y=. 'for_?'
  elseif. 'label_' -: 6{.y do. y=. 'label_?'
  end.
  top=. <y
  if. top e. DICT do.
    >DICTX {~ DICT i.top
  else.
    ''
  end.
else.
  ''
end.
)

NB. =========================================================
NB. return nuvoc help topic ndx from primitive
helpndx_nuvoc=: 3 : 0
top=. <,y
if. top e. DICTNV do.
  >DICTNVX {~ DICTNV i.top
else.
  ''
end.
)

NB. =========================================================
helppos=: 3 : 0
'class pos txt'=. y
txt=. ucp txt
txt=. txt {.~ pos + (pos }. txt) i. LF
ndx=. - (|. txt) i. LF
pos=. pos - ndx + #txt
txt=. ndx {. txt

NB. ---------------------------------------------------------
NB. check for context-sensitive error handling:
if. '[-' -: }. 3 {. txt do.
  if. helperror utf8 txt do. '' return. end.
end.

NB. ---------------------------------------------------------
NB. check for word formation:
if. class=0 do.
  at=. pos{txt,LF          NB. current position
  as=. pos{LF,txt          NB. previous position
  if. *./ (at,as) e. ' ',LF do.
    '' [ helpword utf8 txt return.
  end.
end.

NB. ---------------------------------------------------------
NB. handle dictionary or definition entry:
sep=. {.~ <./ @ (i.&('() ''',{.a.))
beg=. sep&.|. pos{.txt
bit=. beg,sep pos}.txt

if. 0=#bit-.' ' do.
  txt=. ''
else.
  wds=. ;:utf8 bit
  len=. #&>}:wds
  txt=. > wds {~ 0 i.~ (#beg)>:+/\len
end.

txt
)

NB. =========================================================
helpsel=: 3 : 0
assert. 2=3!:0 y
s=. dlb@dtb y
if. 0=#s do. return. end.
if. 0=#ContextHelp do. return. end.
for_h. ,ContextHelp do.
  select. h
  case. 'j' do.
    if. #ndx=. helpndx_nuvoc s do.
      ndx return.
    end.
  end.
end.
''
)

NB. =========================================================
helpword=: 3 : 0
r=. ;: :: 0: y
if. r -: 0 do.
  smoutput LF,'word formation failed: ',dlb y
else.
  smoutput r
  smoutput ''
end.
)
NB. NuVoc -- generate Vocabulary/ page name from J primitive (as string)

CBYTE=: 0 : 0
=eq
<lt
>gt
_under
+plus
*star
-minus
%percent
^hat
$dollar
~tilde
|bar
.dot
:co
,comma
;semi
#number
!bang
/slash
\bslash
[squarelf
]squarert
{curlylf
}curlyrt
(parenlf
)parenrt
'apostrophe
"quote
`grave
@at
&amp
?query
0zero
1one
2two
3three
4four
5five
6six
7seven
8eight
9nine
)

cbyte=: (3 : 0)"0
if. y e. 'abcdefghijklmnopqrstuvwxyz' do. < y
elseif. y e. 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' do. < 'cap' ,~ tolower y
elseif. y e. CBYTE {~ I. 1 , }: LF=CBYTE do. < }. LF taketo (CBYTE i. y) }. CBYTE
elseif. do. ''
end.
)

cname=: ; @: cbyte

assert 'eq' 		-: cname '='
assert 'eqco' 		-: cname '=:'
assert 'ncapbcapdot' 	-: cname 'NB.'
NB. defines globals for NuVoc help jumps

j=. <;._2 (0 : 0)
= eq
=. eqdot
=: eqco
< lt
<. ltdot
<: ltco
> gt
>. gtdot
>: gtco
_ under
_. underdot
_: underco
+ plus
+. plusdot
+: plusco
* star
*. stardot
*: starco
- minus
-. minusdot
-: minusco
% percent
%. percentdot
%: percentco
^ hat
^. hatdot
^: hatco
$ dollar
$. dollardot
$: dollarco
~ tilde
~. tildedot
~: tildeco
| bar
|. bardot
|: barco
. dot
.. dotdot
.: dotco
: co
:. codot
:: coco
, comma
,. commadot
,: commaco
; semi
;. semidot
;: semico
# number
#. numberdot
#: numberco
! bang
!. bangdot
!: bangco
/ slash
/. slashdot
/: slashco
\ bslash
\. bslashdot
\: bslashco
[ squarelf
[: squarelfco
] squarert
{ curlylf
{. curlylfdot
{: curlylfco
{:: curlylfcoco
} curlyrt
}. curlyrtdot
}: curlyrtco
" quote
". quotedot
": quoteco
` grave
`: graveco
@ at
@. atdot
@: atco
& ampm
&. ampdot
&.: ampdotco
&: ampco
? query
?. querydot
0: zeroco
1: zeroco
2: zeroco
3: zeroco
4: zeroco
5: zeroco
6: zeroco
7: zeroco
8: zeroco
9: zeroco
_1: zeroco
_2: zeroco
_3: zeroco
_4: zeroco
_5: zeroco
_6: zeroco
_7: zeroco
_8: zeroco
_9: zeroco
a. adot
a: aco
A. acapdot
b. bdot
C. ccapdot
d. ddot
D. dcapdot
D: dcapco
e. edot
E. ecapdot
f. fdot
H. hcapdot
i. idot
i: ico
I. icapdot
j. jdot
L. lcapdot
L: lcapco
M. mcapdot
NB. ncapbcapdot
o. odot
p. pdot
p.. pdotdot
p: pco
q: qco
r. rdot
s: sco
S: scapco
t. tdot
t: tco
T. tcapdot
u: uco
x: xco
)

n=. j i.&> ' '
DICTNV=: n {.each j
DICTNVX=: (n+1) }.each j
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

cocurrent 'base'
