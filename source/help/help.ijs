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
