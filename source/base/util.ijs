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
