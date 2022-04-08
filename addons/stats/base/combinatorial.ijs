NB. stats/base/combinatorial
NB. Sample design

NB. comb v         combinations of size x from i.y
NB. combrep v      combinations of size x from i.y with repetition
NB. combrev v      comb in revolving door order
NB. perm v         permutations of size x from i.y
NB. permrep v      permutations of size x from i.y with repetition
NB. steps v        steps from a to b in c steps

cocurrent 'z'

NB. =========================================================
NB.*comb v combinations of size x from i.y
comb=: 3 : 0
comb~ y
:
k=. i.>:d=. y-x
z=. (d$<i.0 0),<i.1 0
for. i.x do. z=. k ,.&.> ,&.>/\. >:&.> z end.
; z
)

NB. =========================================================
NB.*combrep v combinations of size x from i.y with repetition
combrep=: $:~ : (i.@[ -"1~ [ comb + - 1:)

NB. =========================================================
NB.*combrev v comb in revolving door order
NB. combinations in what Knuth calls "revolving door order"
NB. such that any two adjacent combinations differ by a
NB. single element (Gray codes for combinations).
combrev=: 3 : 0
combrev~ y
:
i=. 1+x
z=. 1 0$k=. i.#c=. 1,~(y-x)$0
while. i=. <:i do. z=. (c#k),.;(-c=. +/\.c)|.@{.&.><1+z end.
|.y-1+z
)

NB. =========================================================
NB.*perm v permutations of size x from i.y
NB. monadic form gives all perms of size i.y (i@! A. i.)
perm=: 3 : 0
z=. i.1 0
for. i.y do. z=. ,/ (0 ,. 1 + z) {"2 1 \:"1 = i. 1 + {: $z end.
:
,/ ({~ perm@#)"1 x comb y
)

NB. =========================================================
NB.*permrep v permutations of size x from i.y with repetition
permrep=: $:~ : (# #: i.@^~)

NB. =========================================================
NB.*steps v steps from a to b in c steps
NB. form: steps a,b,c
steps=: {. + (1&{ - {.) * (i.@>: % ])@{:
