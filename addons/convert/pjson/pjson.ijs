cocurrent 'pjson'
fmtbool=: >@{&('false';'true')
fmtbools=: }.@; @: {&(',false';',true')
fmtnum=: ,@('d<null>'&(8!:2))
fmtnums=: ' ' -.~ }.@,@(',' ,. >@{.@('d<null>'&(8!:1))@,.)
fmtint=: ,@('d<null>0'&(8!:2))
fmtints=: ' ' -.~ }.@,@(',' ,. >@{.@('d<null>0'&(8!:1))@,.)

sep=: }.@;@:(','&,each)
bc=: '{' , '}' ,~ ]
bk=: '[' , ']' ,~ ]

fixchar=: ]

ESC=: _2[\('\';'\\';CR;'\r';LF;'\n';TAB;'\t';(8{a.);'\b';FF;'\f';'"';'\"';'/';'\/')
decesc=: rplc&(1|."1 ESC)
encesc=: rplc&ESC
remq=: ]`(}.@}:)@.('"' = {.)
isbool=: 1=3!:0
isboxed=: 0 < L.
ischar=: 2=3!:0
isfloat=: 8=3!:0
isscalar=: 0 = #@$
quotes=: '"'&,@(,&'"')

false=: 0
true=: 1
NULL=: 0$0
ESS=: a:
nos=: 4 : 0
 s=. x I.@E. y
 i=. s I. s+#x
 (i.#y) e. (s,_1) {~ (i,_1) {~^:a: 0
)
tc=: ,&_1 {~^:a: 0:
nos1=: i.@#@] e. #@[ (tc@(]I.+) { _1,~]) I.@E.
cutcommas=: 3 : 0
y=. ',',y
m=. ~:/\ ('"' = y)  > (_2 (|.!.0) '\\' nos y) < (_1 (|.!.0) '\"' E. y)
m=. *./ (m < y=','), 0 = _2 +/\ @ (-/)\ m <"1 '{}[]'=/y
m <@dltb;._1 y
)
dec=: 3 : 0
dec1 dltb ' ' (y I.@:e. TAB,CRLF)} y
)
dec1=: 3 : 0
if. 0=#y do. '' return. end.
if. y-:'null' do. NULL return. end.
select. {. y
case. ESS do. ". }. y
case. '{' do. dec_object y
case. '[' do. dec_array y
case. '"' do. decesc }.}:y
case. do. dec_num y
end.
)
dec_array=: 3 : 0
y=. dltb }.}:y
if. 0=#y do. $0 return. end.
if. -. y +./@:e. '"{[' do. ,dec_num y return. end.
dec1 each cutcommas y
)
dec_num=: 3 : 0
nms=. ;: 'false true null'
res=. 0 ". ' ' (I.y=',')} y
if. -. 1 e. ,nms E.&> <y do. return. end.
nos=. <;._1 ',',y -. ' '
'f t n'=. nos&(I.@:= <) each nms
res=. true t} false f} res
if. #n do. ({.NULL) n} res end.
)
dec_object=: 3 : 0
if. 2=#y do. '' return. end.
dec_object1 &> a: -.~ cutcommas }.}:y
)
dec_object1=: 3 : 0
n=. 1 i.~ (y=':') > ~:/\ ('"'= y) > (_2 (|.!.0) '\\' nos y) < (_1 (|.!.0) '\"' E. y)
k=. decesc remq dltb n {. y
v=. dec1 dltb (n+1) }. y
k;<v
)
enc=: 3 : 0
if. 1<#$y do.
  if. isboxed y do.
    enc_dict y
  else.
    bk sep <@enc"_1 y
  end.
elseif. isbool y do.
  enc_bool y
elseif. isboxed y do.
  bk sep enc each y
elseif. ischar y do.
  if. ESS = {. y do. }. y return. end.
  enc_char y
elseif. isfloat y do.
  enc_num y
elseif. do.
  enc_int y
end.
)
enc_bool=: bk @ fmtbools`fmtbool @. isscalar
enc_char=: quotes @ encesc @ fixchar
enc_num=: bk @ fmtnums`fmtnum @. isscalar
enc_int=: bk @ fmtints`fmtint @. isscalar
enc_dict=: 3 : 0
'rank>2 argument not supported' assert 2 = #$y
'rank 2 argument must be a dictionary' assert (2 = {:$y) > 0 e. ischar &> {."1 y
key=. (enc_char each ({."1 y)) , each <':'
val=. enc each {:"1 y
rep=. ;key,.val ,each <',',LF
bc LF,(_2}.rep),LF
)
finalize_pjson_^:(3=(4!:0)@<) 'finalize_pjson_'
cocurrent 'base'
