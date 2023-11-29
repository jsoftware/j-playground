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
9!:7 {. Boxes_j_
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
// only execute the startup.ijs if the querystring doesn't have nostartup... this allows a person to fix a broken startup
// we don't need to check for the presence of startup.ijs because it will execute an empty string if it doesn't exist
if (window.location.href.indexOf('nostartup')==-1) { 
  //needs to run in a setTimeout because J can't recursively call Javascript which calls J for some reason
  setTimeout(function() { jdo1("(0!:0) File_plj_ 'startup.ijs'") },10);
}

)
(2!:0) startupJS


cocurrent 'z'