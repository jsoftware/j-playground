NB. convert/misc/base64
NB. Convert to/from base64 representations
NB. version: 1.0.3

NB. main functions:
NB. new version only worked for little endian
NB.   tobase64         to base64 representation
NB.   frombase64       from base64 representation

cocurrent 'z'

BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
BASE64_2=: (,/ (,"0)/~i.64){BASE64

NB. =========================================================
NB.*tobase64_old v To base64 representation
tobase64_old=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)

NB. =========================================================
NB.*frombase64_old v From base64 representation
frombase64_old=: 3 : 0
pad=. _2 >. (y i. '=') - #y
pad }. a. {~ #. _8 [\ , (6#2) #: BASE64 i. y
)

NB. =========================================================
NB.*tobase64 v To base64 representation
tobase64=: 3 : 0
if. pad=. (0 2 1 i. 3 | # y) do.
 n=. _2 ic , |."1 ({.a.),"(1) _3]\ y,pad#{.a.
else.
 n=. _2 ic , |."1 ({.a.),"(1) _3]\ y
end.
a=. BASE64_2{~ 4095 (17 b.) n
if. 0=pad do.
 , a,.~ BASE64_2{~ 4095 (17 b.) _12 (33 b.) n
else.
 '=' ((-pad){. _2 _1)} , a,.~ BASE64_2{~ 4095 (17 b.) _12 (33 b.) n
end.
)

NB. =========================================================
NB.*frombase64 v From base64 representation
frombase64=: 3 : 0
if. 0=#y do. '' return. end.
assert. 0=4|#y
if. 1=pad=. +/ '='=_2{.y do.
 'a b'=. |: _2]\ BASE64_2 i. _2]\(}:y),'A'
else.
 'a b'=. |: _2]\ BASE64_2 i. _2]\y
end.
a=. , |.@:}:("1) _4]\ 2 ic (12 (33 b.) a) (23 b.) b
if. pad do. (-pad)}.a end.
)

NB. j902 doesn't need this base64 addon, just for code backward compatibility
3 : 0''
try.
 3!:10''
 tobase64=: 3!:10
 frombase64=: 3!:11
catch. end.
EMPTY
)

NB. =========================================================
Note 'Testing'
A=: '1';'12';'123';'1234';'12345';'123456';'hi there';'qwerty'
(-: frombase64@tobase64) &> ,each A
(-: frombase64@tobase64_old) &> ,each A
(-: frombase64_old@tobase64) &> ,each A
(-: frombase64_old@tobase64_old) &> ,each A
(tobase64 -: tobase64_old) &> ,each A
(frombase64 -: frombase64_old) &> ,each tobase64 each A
(frombase64 -: frombase64_old) &> ,each tobase64_old each A
)
