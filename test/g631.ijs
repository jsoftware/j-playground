1:@:(dbr bind Debug)@:(9!:19)2^_44[(echo^:ECHOFILENAME) './g631.ijs'
NB. u&.v ----------------------------------------------------------------

12 _12 _12 12 = 3 3 _3 _3 +&.^. 4 _4 4 _4
7 _1 1 _7     = 3 3 _3 _3 *&.^  4 _4 4 _4

1 -: +&.^./''
0 -: *&.^ /''

totient =. * -.@%@~.&.q:
t1      =. 1: #. 1: = (+.i.)
(t1 -: totient)"0 x=:>:?2 10$1000


NB. f&.> ----------------------------------------------------------------

(100$<1) -: #&.>?100$1000
(,&.>6 1 4 4) = $&.>;:'Cogito, ergo sum.'
(,&.>6 1 4 4) = $&.>(u:&.>) ;:'Cogito, ergo sum.'
(,&.>6 1 4 4) = $&.>(10&u:&.>) ;:'Cogito, ergo sum.'
(,&.>6 1 4 4) = $&.>s:@<"0 &.> ;:'Cogito, ergo sum.'

(<"0 (>x)+ >y) -: x  +&.>y [ x=:   ?1000     [ y=:   ?1000
(<"0 (>x)>.>y) -: x >.&.>y [ x=:   ?1000     [ y=:<"0?1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?1000     [ y=:   ?1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?1000     [ y=:<"0?1000

(<"0 (>x)+ >y) -: x  +&.>y [ x=:   ?1000     [ y=:   ?100$1000
(<"0 (>x)>.>y) -: x >.&.>y [ x=:   ?1000     [ y=:<"0?100$1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?1000     [ y=:   ?100$1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?1000     [ y=:<"0?100$1000
                                                         
(<"0 (>x)+ >y) -: x  +&.>y [ x=:   ?100$1000 [ y=:   ?1000
(<"0 (>x)>.>y) -: x >.&.>y [ x=:   ?100$1000 [ y=:<"0?1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?100$1000 [ y=:   ?1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?100$1000 [ y=:<"0?1000

(<"0 (>x)+ >y) -: x  +&.>y [ x=:   ?100$1000 [ y=:   ?100$1000
(<"0 (>x)>.>y) -: x >.&.>y [ x=:   ?100$1000 [ y=:<"0?100$1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?100$1000 [ y=:   ?100$1000
(<"0 (>x)* >y) -: x * &.>y [ x=:<"0?100$1000 [ y=:<"0?100$1000

'length error' -: (i.12)  +&.> etx i.3 4
'length error' -: (i.3 4) +&.> etx i.4 3

NB. f&> ----------------------------------------------------------------

NB. unaligned memory access
(,:'bbbbb') -: (,3) }.&> ,<'aa bbbbb'
11111 22222 33333 555555 -: ". 36 37 38 31 }.&> 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 11111'; 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 22222'; 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 33333'; 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 555555'


NB. x u&.(a:`v) y  and  x u&.(v`:a:) y -----------------------------------------------------------

'domain error' -: +&.(a:`^.) etx i. 5
'domain error' -: +&.(^.`a:) etx i. 5
'domain error' -: ex '+&.(^.`^.)'
'domain error' -: ex '+&.(a:`a:)'
'domain error' -: ex '+&.(^.`a:`a:)'
'domain error' -: ex '+&.(^.`1) etx'
'domain error' -: ex '+&.(1`^.) etx'
'domain error' -: ex '+&.(,. ^.`a:)'
(^ 1 + ^. y) -: 1 +&.(a:`^.) y =: i. 5
(^ 1 + ^. x) -: (x =: i. 5) +&.(^.`a:) 1
(^ x + ^. y) -: (x =: 1 2) +&.(a:`^.) y =: i. 2 5
(x <@(+"1 >)"1 0 y) -: (x =: 1 2) +"1&.(a:`>) y =: <"2 i. 5 2
(x <@(+"1 2 >)"1 0 y) -: (x =: 1 2) +"1 2&.(a:`>) y =: <"2 i. 2 5
(x <@(+"1 2 >)"1 0 y) -: (x =: 1 2) +"1 2&.(a:`>) y =: (<"2 i. 2 5) ,. (<"2 i. 2 7)

0 0 0 -: +&.(a:`^.) b. 0
0 1 0 -: p.&.(a:`^.) b. 0
0 0 1 -: +"1&.(^.`a:) b. 0
_ _ _ -: +&.:(a:`^.) b. 0


NB. Verify that named adverbs are stacked if the value is nameless
o =: >
a =: &.o
pe =: >: a
(<5) -: pe <4
o =: &
'domain error' -: pe etx <4
'>:&.o' -: 5!:5 <'pe'
e =: &.>
(<5) -: (e =: >:)e <4  NB. If e were stacked by reference, this would fail
o =: >
3 : 0 ''
try.
a =: &.o
(a =: >:)a etx <4  NB. fails when a changes part of speech
0
catch.
1
end.
)
a =: &.o
(<<5) -: (>: a =: &.>)a 4
a =: &.o
5 -: (>: a =: &.])a 4   NB. OK to redefine a nameful entity as nameless; the new definition is used both places 

4!:55 ;:'a e o pe t1 totient x y '


