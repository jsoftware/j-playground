NB. math/misc/matfacto
NB. Matrix factorization
NB. version: 1.0.0

NB. choleski        Choleski decomposition
NB. lud             LU decomposition of square matrix
NB. LU              LU decomposition of square/wide matrix
NB. LUcheck         as for LU with checks
NB. qrd             QR decomposition of matrix

require 'math/misc/linear'

NB. =========================================================
NB.*choleski v Choleski decomposition of matrix y
NB. given L =. choleski A
NB.       A -: L mp h L
NB. see https://code.jsoftware.com/wiki/Essays/Cholesky_Decomposition
choleski=: 3 : 0
mp=. +/ .*            NB. matrix product
h=. +@|:              NB. conjugate transpose
r=. #A=. y
if. 1>:r do.
  assert. (A=|A)>0=A  NB. check positive definite
  %:A
else.
  'X Y t Z'=. , (;~ r $ (>. -:r){.1) <;.1 A
  L0=. choleski X
  L1=. choleski Z-(T=. (h Y) mp %.X) mp Y
  L0,(T mp L0),.L1
end.
)

NB. =========================================================
NB.*lud v LU decomposition of square matrix y
NB. returns 3 elements: L U P where
NB.   L is lower triangular
NB.   U is upper triangular
NB.   P is a permutation of the identity matrix,
NB.     that gives the pivoting used.
NB. The original matrix is: (L mp U) %. P
lud=: 3 : 0
r=. #y
ir=. idmat r
'A b'=. 2 {. gauss_elimination y,.ir
U=. clean (r,r){.A
f=. (0,r)}.A
L=. clean b{%.f
P=. b{ir
L;U;P
)

NB. =========================================================
NB.*LU v LU decomposition of matrix y
NB. for matrix where <:/$A
NB. returns 3 elements: p L U where
NB.   p is a permutation vector,
NB.     that gives the pivoting used.
NB.   L is lower triangular
NB.   U is upper triangular
NB. The original matrix is: p {"1 L mp U
NB. See https://code.jsoftware.com/wiki/Essays/LU_Decomposition
LU=: 3 : 0
 'm n'=. $ A=. y
 if. 1=m do.
  p ; (=1) ; p{"1 A [ p=. C. (n-1);~.0,(0~:,A)i.1
 else.
  m2=. >.m%2
  'p1 L1 U1'=. LU m2{.A
  D=. (/:p1) {"1 m2}.A
  F=. m2 {."1 D
  E=. m2 {."1 U1
  FE1=. F mp %. E
  G=. m2}."1 D - FE1 mp U1
  'p2 L2 U2'=. LU G
  p3=. (i.m2),m2+p2
  H=. (/:p3) {"1 U1
  (p1{p3) ; (L1,FE1,.L2) ; H,(-n){."1 U2
 end.
)

NB. =========================================================
NB.*LUcheck v LU decomposition of matrix y with checking
NB. same arguments and result as LU 
LUcheck=: 3 : 0
 A=. y
 assert. <:/$A
 'p L U'=.z=. LU A
 'm n'=. $A
 assert. (($p) -: ,n) *. (i.n) e. p
 assert. (($L) -: m,m) *. ((0~:L)<:(i.m)>:/i.m) *. 1=(<0 1)|:L
 assert. (($U) -: m,n) *.  (0~:U)<:(i.m)<:/i.n
 assert. A -: p {"1 L mp U
 z
)

NB. =========================================================
NB.*qrd v QR decomposition of matrix y
NB. result has 2 elements: Hermitian matrix;square upper triangular matrix
qrd=: 128!:0


Note 'Testing ...'
A=: _8]\ 6 0 0 0 0 19 0 0, 0 0 6 0 0 0 0 0, 0 0 0 2 0 0 0 4, 4 0 0 0 16 0 0 0, 0 8 2 0 0 0 19 0, 1 0 0 0 17 0 0 13
A1=: _3]\ 1 4 6, 4 0 3, 6 3 2    NB. not Positive definite
A2=: _4]\ 33 7j_8 7j_10 3j_4, 7j8 28 2j4 _10j_11, 7j10 2j_4 22 3j3, 3j4 _10j11 3j_3 16
A3=: (+/ .* |:) _10 + 10 20 ?.@$ 20

choleski 6 6 {. A  NB. fails as not PD 
choleski A1        NB. fails as not PD
{{y -: (] mp +@|:) choleski y}} every A2;A3
lud A              NB. fails as not square
lud 6 6 {. A
{{ y -: clean (L mp U) %. P [ 'L U P'=. lud y }} 6 6 {. A
LU 6 6 {. A
{{ y -: p {"1 L mp U [ 'p L U'=. LU y }} 6 6 {. A
LU A
{{ y -: p {"1 L mp U [ 'p L U'=. LU y }} every A;A1;A2;A3
)
