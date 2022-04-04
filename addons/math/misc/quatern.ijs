NB. math/misc/quatern
NB. Definitions for quaternions
NB. version: 1.0.0
NB. real quaternions:
NB.  - stored as real arrays with last dimension of length 4

NB. Main definitions:
NB.   qncon      conjugate
NB.   qndivl     division (left quotient)
NB.   qndivr     division (right quotient)
NB.   qnmul      multiplication
NB.   qnrec      reciprocal
NB.
NB.   qnpolar    convert to/from polar form
NB.
NB. Other:
NB.   qndivml    division (using matrix divide, left quotient)
NB.   qndivmr    division (using matrix divide, right quotient)
NB.   qnfmt      format a quaternion as a literal
NB.   qnumbers   obverse of qnfmt

NB. e.g.
NB.      2 3 5 7 qnmul 1 2 3 4
NB.   _47 6 13 14
NB.
NB.      (1 2 3 4 qndivl 2 3 5 7) qnmul 2 3 5 7
NB.   1 2 3 4
NB.
NB.      2 3 5 7 qnmul (1 2 3 4 qndivr 2 3 5 7)
NB.   1 2 3 4
NB.      qnfmt 1 2 3 4
NB.   1i2j3k4
NB.      qnumbers '2i3j5k7'
NB.   2 3 5 7
NB. =========================================================

mp=. +/ . *

j=. ,: =i.4
j=. j, 0 1 0 0, _1 0 0 0, 0 0 0 _1,: 0 0 1 0
j=. j, 0 0 1 0, 0 0 0 1, _1 0 0 0,: 0 _1 0 0
j=. j, 0 0 0 1, 0 0 _1 0, 0 1 0 0 ,: _1 0 0 0
qnmat=. mp & j

NB.*qncon v Conjugate
qncon=: 1 _1 _1 _1 & * "1

NB.*qnmul v Multiplication
NB. eg:   2 3 5 7 qnmul 1 2 3 4
NB.    _47 6 13 14
qnmul=: (mp qnmat) f. "1

NB.*qnrec v Reciprocal
qnrec=: (1 _1 _1 _1 & * % +/ @: *:) "1

NB.*qndivl v Division (left quotient)
qndivl=: (qnmul qnrec) f. "1

NB.*qndivr v Division (right quotient)
qndivr=: (qnmul~ qnrec) f. "1

NB.*qndivml v Division (using matrix divide, left quotient)
qndivml=: {."1 @ %. & (|: @ qnmat) f. "1

NB.*qndivmr v Division (using matrix divide, right quotient)
qndivmr=: {. @ %. & qnmat f. "1

NB. =========================================================
NB.*qnpolar v Convert to/from polar form
NB. x is: 0 convert to polar form (default)
NB.       1 convert from polar to standard form
NB.
NB. polar form has 3 elements: h (modulus)
NB.                            t (theta)
NB.                            u (unit quaternion)
qnpolar=: 3 : 0 "1
0 qnpolar y
:
if. x=0 do.
  h=. %: +/ *: y
  t=. _2 o. ({.y) % h
  u=. j % %: +/ *: j=. 0 1 1 1 * y
  h;t;u
else.
  'h t u'=. y
  h * (4 {. cos t) + u * sin t
end.
)

NB. qnfmt v format quaternions
qnfmt=: 3 : 0 "1
  b=. 1,}.0 0 0 0~:,y NB. supress imaginary zeros
  }.;b#' ijk'(, ":)each y
)

NB. internal helper for qnumbers: parse a single element of a quaternion
qnum=.4 :0
  if. {.y e. 'ijk' do.
    (x ". }. y) * ' ijk'={.y
  else.
    4 {. x ". y
  end.
)   

NB. qnumbers v extract quanternions from literal representation
qnumbers=: qnum f. 1 : 0 ("1)
  _. qnumbers y
:
  if. ' ' e. y do. x qnumbers every cut y return. end.
  if. ('b' e. y) +. (-. 1 e. 'ijk' e. y) +. (-. 1 e. '0123456789' e. y) do. 4 {. x ". y return. end.
 +/(x&u;.1~ (1) 0} e.&'ijk') y
)
 
