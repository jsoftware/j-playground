NB. IEEE 64 bit representation of floating point number
NB.
NB. e.g.
NB.   ieee64 %7

NB. =========================================================
NB.*ieee64 v IEEE 64 bit representation
ieee64=: 3 : 0
if. 1 ~: #y do. 'one number only' return. end.
hex=. '0123456789ABCDEF'
f=. 3}. n=. ,|.16 16#:a. i. (IF64{28 48)}.3!:1 [ 0.1,y
e=. 1}. s=. ,2 2 2 2#:3$n
r=. <'Decimal representation:  ',":!.17 y
r=. r,<'Internal representation: ',n{hex
r=. r,<''
if. *./0=e,f do.
  s=. (16{.":{.s),'n/a'
  e=. f=. (16{.'0'),'zero'
elseif. 1 */ .=e do.
  s=. e=. f=. 'n/a'
elseif. 1 do.
  s=. (16{.":{.s),(({.s){'+-'),'ve'
  e=. (16{.1":e),'2^',":(2#.e)-1023
  f=. (16{.f{hex),":!.17 [ >:(16#.3}.n)%16^13
end.
r=. r,<'                  Value           Use'
r=. r,<' Sign[0]          ',s
r=. r,<' Exponent[1-11]   ',e
r=. r,<' Decimal[12-63]   ',f
}.;LF,&.>r
)
