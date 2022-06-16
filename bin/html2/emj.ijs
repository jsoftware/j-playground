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
data=. fread getscripts_j_ y
(2!:0) 'if (confirm("Are you sure you wish to overwrite the editor?")) { ecmset(jgetstr("data")) }'
)

NB. =========================================================
NB. word formation on a single line of code (no LF)
NB. if OK, returns LF-delimited list
NB. otherwise 0 on failure
towords=: 3 : 0
try.
  }. ; LF ,each ;: y
catch.
  0
end.
)



NB. credit to https://plj541.github.io/Tools/JPlayground.txt
NB. J-Playground verbs for using Javascript in the browser

0!:100 jPlay=: 0 : 0
9!:7'+++++++++|-'
(<~.'plj'; 18!:2 <'base') 18!:2&> <"0 ;:'base pj'
cocurrent'plj'

NB. J-Playground verbs for using Javascript in the browser

Say=: {{
 NB. Should display an intermediate value
 y 1!:2 [2
}}

Ask=: {{
 NB. Web replacement for  1!:1 [1
 '' Ask y
:
 (2!:0) 'prompt("', y, '", "', '")',~ jsEnc_pj_ x [Say y
}}

File=: {{
 2!:0 'window.localStorage.getItem("', y, '")'
:
 y [2!:0 'window.localStorage.setItem("', y, '","', '")',~ jsEnc_pj_ x
}}

Files=: {{
 myItems=. ''
 for_index. i.". 2!:0 '""+ window.localStorage.length' do.
  myItems=. myItems, <2!:0 'window.localStorage.key(', ')',~ ":index
 end.
 Across Sort myItems
:
 2!:0 'window.localStorage.removeItem("', '")',~ jsEnc_pj_ x
 'Removed'
}}

Edit=: {{
 2!:0 'ecm.getDoc().getValue()'
:
 2!:0 'ecm.getDoc().setValue("', '")',~ jsEnc_pj_ x
}}

Link=: {{
 2!:0 'window.open("', '")',~ y
}}

Page=: {{
 URL_httpget_=: y
 2!:0 httpgetJS_jpacman_
 RESPONSE_httpget_
}}

Next=: {{
 if. ' '= {.0$ y do. y=. 0 [next_pj_=: <;._1 File y end.
 if. y< #next_pj_ do. 
  now=. ;y{ next_pj_
  if. ']'= {.now do. Do }.now
  else. ''[ Say now end.
  if. (y=. >:y)< #next_pj_ do. 'Next ', ":y end.
 else. 'NB. That''s all folks!' end.
}}

jsEnc_pj_=: {{y Replace ForEach 2 '\';'\\';'"';'\"';LF;'\n';CR;'\r';TAB;'\t'}}

Vr=: {{
 NB. Visual Representation with {{ }} appearance
 if. 0= 4!:0<y do. t=.<;._1' 1 a. 2 3.5 j < x r , , s1 sa. s2 s3.5 sj s< sn u2 u4'
  LF2,~ 'NB. Noun: ', y, '=: ', (":$d), '$ of ', ;t{~ 2^. 3!:0 d=. ".y
 else. t=. >('1234'i. {.d){ ')a'; ')c'; ''; ')d'; 'X' [d=. 5!:5 <y
  if. ' : '-: 3{.}.d do. e=. 4{. }.d
   if.     ' : 0'-:  e do. d=. }:d}.~ #e=. (d i. LF){. d=. 5}. d
   elseif. ' : '''-: e do. d=. ".d}.~ -#e=. (>:d i: '''')}. d=. 4}. d
   elseif. ' : ('-:  e do. d=. 4}. d
    if. +./(;:')"(')E. ;:d do. d=. d}.~ -#e=. d}.~ >:1 i:~ ') " ('E. d
    else. d=. d}.~ -#e=. (>:d i: ')')}. d end.
    d=. LF,LF,~ LF Join~ ". d
   else. ^'DOMAIN ERROR' end.  NB. Unrecognized
   LF2,~ y, '=: {{', t, d, '}}', e
  else. LF2,~ y, '=: ', d end.
 end.
}}

NB. String verbs with .Net names

Join=: ([:; [:}. [:,[ ,.~ [:<])" 1
WhiteSpace=: WS=: 32 13 10 9{ a.
TrimStart=: ([#~ [:-. [:*./\ e.)" 1
TrimEnd=: ([#~ [:-. [:*./\. e.)" 1
Trim=: (TrimStart TrimEnd ])" 1
StartsWith=: (([:,])-: [{.~ <.&#)" 1
EndsWith=: (([:,])-: [{.~ [:-([:#[)<. [:#])" 1

Split=: {{
 NB. Split x into boxes at each y
 if. ''-: x do. ,a: return. end.
 if. ''-: y do. ,<,x return. end.
 if. 1= #y do.
  <;._2 x, y
 else.
  if. #now=. x noOverlap_pj_ y do.
   (x{.~ {.now); (#y)}. &.> now indexCut_pj_ x
  else.
   ,<,x
  end.
 end.
}}" 1

Replace=: {{
 NB.    Usage: text Replace old; new
 NB. Multiple: text Replace ForEach 2 ;:'this that now then'
 'old new'=. y
 now=. x noOverlap_pj_ old
 if. #now do.
  if. 1 1-: #&> old; new do.
   x now}~ {.new
  else.
   ;(x{.~ {.now); (#old) new &,@}. &.> now indexCut_pj_ x
  end.
 else.
  x
 end.
}} " 1

ForEach=: {{
 NB. Usage: verb ForEach eachSize multipleEachSizeArgs
:
 if. _ -.@-: n=. {.,n do.  NB. When n is _, y must already be grouped
  y=. |. <"1 (n,~ n%~ #y) $ y=. ,y  NB. Box arguments n at a time
 end.
 > u~ &.>/ y, <x
}}

indexCut_pj_=: {{
 NB. Cut with x as indexes instead booleans
 y <;.1~ 1 x} 0#~ #y
}}

noOverlap_pj_=: {{
 NB. Find non-overlapping indexes of y in x
 if. ''-: y do. i. 0 return. end.
 now=. y I.@E. x
 if. 2= +/y E. y, y do. now  NB. Cannot overlap
 else. all=. now I. now+ #y
  (i.&_1{.]) (now, _1){~ (all, _1){~ ^:a: 0
 end.
}}

Diff=: {{
 NB. Usage: x [m] Diff n y
 m '' Diff n y
:
 n=. 2$ n  NB. n should be ⎕IO for x and y, 1 for external editors, 0 for J nouns
 x=. boxedLines_pj_ x [y=. boxedLines_pj_ y
 if. x-: y do. 'They are identical' return. end.
 if. m-: '' do. m=. ',Old lines,New lines' end.
 label=. ' ↑ ', old, ' --   -- ↓ ', new, LF ['old new'=. <;._1 m
 label=. label,~ '-'#~ #":#x ['old new'=. n
 (x old diffLines_pj_ y), label, y new diffLines_pj_ x
}}

boxedLines_pj_=: {{
 NB. Provide boxed lines from one of three possible formats
 if. L. y do. y                  NB. Already boxed lines
 elseif. LF e. y do. y Split LF  NB. Contains LF's
 else. LF Split~ File y end.     NB. A file name
}}

diffLines_pj_=: {{
 NB. Display lines which are missing in the other version, m is ⎕IO
:
 'No lines are missing', LF  NB. Which lines in x are missing in y
 if. 0~: #gone=. (i=. z= #y)# x [z=.y i. x do.
  ;(<"1 ' | ',"1~ ":,. m+ I. i),. gone,. <LF
 end. 
}}

NB. Output display verbs

Across=: {{
 2 foldBoxes_pj_ y
}}

Fmt=: {{
 NB. -    +   -   +  mp Before; nq After; b[zero]; d[nill]; r[fill]
 'm[ (]p[  ]n[)]q[ ]c0.2' Fmt y
:
 if. 0 e. $y do. ''$~ $y return. end.
 if. L. x do.
  x=. }: ;(<'m[ (]p[  ]n[)]q[ ]⍕,') Replace&.> <"1 x,.~ <'⍕'
 end.
 x 8!:2 y
}}

Unbox=: {{
 NB. Remove boxing characters from result
 was=. 9!:6 ''
 9!:7 [11# rep=. 30{ a.
 9!:7 was [now=. ": <y
 now=. 1 1}. _1 _1}. now
 rho=. $now=. (-.*./"1 now= rep)# now 
 rho$ ' ' (I. now= rep)} now=. ,now
}}

foldBoxes_pj_=: {{
 NB. Format the disclose of boxed characters into lines
 insert=. _1+ +/\ |. (WIDTH_pj_+ m) foldBoxes_pj_/ |. 0, 0,~ m+ #&> y
 (->:m)}. LF insert }'X',~ ;y ,&.> <m# ' '
:
 if. m> next=. x+ {.y do. next, }.y
 else. x, y end.
}}

WIDTH_pj_=: 67

Sort=: {{
 NB. Dictionary Sort
 'a' Sort y
:
 x=. 3| 'ad AD /\'i. {.x
 if. x= 2 do. ^'Unrecognized Sort option' return. end.
 y /:`\: @. x Keys >y
}}

Keys=: {{
 NB. Provide the right argument for Dictionary Sort
 KEYS_pj_ Keys y
:
 if. ''-: y do. y return. end.
 if. x +.&(2 ~: #@$) y do. ^'Two matrices are required' end.
 (1 2* $y)$ ,0 2 1|: |."1 (0 1* $x)#: (,x) i. y
}}

KEYS_pj_=: 1|."1 >;._2 [{{)n
0 (abcdefghijklmnopqrstuvwxyz
1')ABCDEFGHIJKLMNOPQRSTUVWXYZ
2.[
3!]
4?{
5:}
6;@
7,#
8_$
9-%
 =^
 +&
}}

NB. Utility combinations with names I can remember

Do=: {{
 0!:101 y
:
 if. x-: y do. x=. 100 end.
 0!:x y
}}

Names=: {{
 Across (<,'y')-.~ 4!:1 y, (y-: '')# i.4
:
 18!:1 y, (y-: '')# i.2
}}

Erase=: {{
 4!:55 ([: ,;: ::]) y
:
 18!:55 ".&> y=. ([: ,;: ::]) y
  4!:55 y
}}

NB. run startup.ijs
startupJS=: 0 : 0
if (window.location.href.indexOf('nostartup')==-1) { 
  setTimeout(function() { jdo1("(0!:0) File_plj_ 'startup.ijs'") },10);
}

)
(2!:0) startupJS


cocurrent 'z'
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

openscriptJS=: 0 : 0
 ecm.getDoc().setValue(jgetstr("RESPONSE_httpget_"));
 ecm.setCursor(0,1e8);
 ecm.focus();
)

NB. open a script on github
openscript=: 3 : 0
 httpget y;3;''
 (2!:0) openscriptJS
)

openscript_z_=: openscript_jpacman_

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
