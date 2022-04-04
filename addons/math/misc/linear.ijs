NB. math/misc/linear
NB. Solve linear equations
NB. version: 1.0.0

NB. =========================================================
NB. elimination functions:
NB.   gauss_elimination    Gauss elimination
NB.   gauss_jordan         Gauss-Jordan elimination
NB.
NB.   back_sub             Back substitution
NB.
NB. =========================================================
NB. iterative methods for solving Ax=B
NB.   gauss_seidel         Gauss-Seidel iteration
NB.   jacobi_iteration     Jacobi iteration
NB.
NB. Typically gauss_seidel converges faster than jacobi, however for
NB. some matrices, jacobi will converge while gauss_seidel does not.

require 'math/misc/matutil'

NB. =========================================================
NB.*gauss_elimination v Gauss elimination (partial pivoting)
NB. y is: (augmented) matrix
NB. x is: optional minimum tolerance, default 1e_15.
NB.   If a column below the current pivot has numbers of magnitude all
NB.   less then x, it is treated as all zeros.
NB.
NB. returns 3 elements: matrix;permutation;row swaps
NB.        where: matrix is in row-echelon form
NB.        permutation{matrix restores the original row order
NB.        row swaps is a matrix of rows that were swapped
gauss_elimination=: 3 : 0
1e_15 gauss_elimination y
:
A=. y
'r c'=. $A
rws=. i.r
i=. j=. 0
p=. ''
max=. i.>./
while. (i<r-1) *. j<c do.
  k=. max col=. | i}. j{"1 A
NB. if all col < tol, set to 0:
  if. 0 < x-k{col do.
    A=. 0 (<(i}.rws);j) } A
NB. otherwise sort and pivot:
  else.
    if. k do.
      p=. p,t=. <i,i+k
      A=. t C. A
    end.
    A=. (i,j) ppivot A
    i=. >:i
  end.
  j=. >:j
end.
q=. (,rws&-.) C. boxopen p
A;q;>p
)

NB. =========================================================
NB.*back_sub v Uses back substitution to solve Ax=b for matrix A (x) and vector b (y)
NB. y is: vector
NB. x is: matrix in row-echelon form
NB. eg: (}:"1 back_sub {:"1) 0{:: gauss_elimination A ,. b
back_sub=: 4 : 0
  A=. (% diag) x
  b=. y (% diag) x
  for_i. i. -#b do.
    b=. ((i{b) - b +/@:*&((i+1)&}.) i{A) i} b
  end.
)

NB. =========================================================
NB.*gauss_jordan v Gauss-Jordan elimination (full pivoting)
NB. y is: (augmented) matrix
NB. x is: optional minimum tolerance, default 1e_15.
NB.   If a column below the current pivot has numbers of magnitude all
NB.   less then x, it is treated as all zeros.
NB. eg: gauss_jordan Matrix
NB. if used to compute matrix inverse, first stitch on the identity matrix
NB. eg: gauss_jordan (,. idmat@#) Matrix
gauss_jordan=: 3 : 0
1e_15 gauss_jordan y
:
A=. y
'r c'=. $A
rws=. i.r
i=. j=. 0
max=. i.>./
while. (i<r) *. j<c do.
  k=. max col=. | i}. j{"1 A
NB. if all col < tol, set to 0:
  if. 0 < x-k{col do.
    A=. 0 (<(i}.rws);j) } A
NB. otherwise sort and pivot:
  else.
    if. k do.
      A=. (<i,i+k) C. A
    end.
    A=. (i,j) pivot A
    i=. >:i
  end.
  j=. >:j
end.
A
)

NB. =========================================================
NB.*gauss_seidel v Solves Ax=b for (diagonally dominant) matrix A, vector b
NB. y is: A;b
NB. x is: optional max iterations (20), error tolerance (1e_8), sor (1)
NB.     sor = successive-over-relaxation constant, between 1 and 2.
NB.         Default 1 means not used.
NB.         Set to adjust the convergence, typically between 1.2 and 1.7.
NB.
NB. returns: table of convergents
gauss_seidel=: 3 : 0
'' gauss_seidel y
:
'A b'=. y
('count';'tol';'sor')=. x,(#x) }. 20 1e_8 1
max=. (i.>./)@|

M=. (] * ltmat@#) A
Mi=. %.M

N=. Mi mp M-A
b=. Mi mp b
r=. ,: t=. b

while. count=. <:count do.
  t=. (sor * b + N mp t) + t * -.sor
  r=. r,t
  if.
    big=. (<_1 _2;max t){r
    (-/big) <&| tol*{.big
  do. break. end.
end.
)

NB. =========================================================
NB.*jacobi_iteration v Solves Ax=b for (diagonally dominant) matrix A, vector b
NB. y is: A;b
NB. x is: optional max iterations (20), error tolerance (1e_8)
NB. returns: table of convergents
jacobi_iteration=: 3 : 0
'' jacobi_iteration y
:
'A b'=. y
('count';'tol')=. x,(#x) }. 20 1e_8
max=. (i.>./)@|

d=. diag A
N=. (d %~ diagmat - ]) A
b=. d %~ b
r=. ,: t=. b

while. count=. <:count do.
  t=. b + N mp t
  r=. r,t
  if.
    big=. (<_1 _2;max t){r
    (-/big) <&| tol*{.big
  do. break. end.
end.
)

NB. =========================================================
Note 'testing...'
 NB. solve Ax=b for x
 A=: 6 1 _2 0 0, 0 4 0 _1 0, 1 _1 5 2 1, _1 0 1 5 0,: 0 1 0 _1 3
 b=: _2.2 _4.4 16.5 _19.8 18.7
 gauss_elimination A,.b        NB. get row-echelon form of A,.b
 (}:"1 back_sub {:"1) 0{:: gauss_elimination A,.b  NB. solve for x
 gauss_jordan A,.b             NB. solve for x
 gauss_jordan (,. idmat@#) A   NB. calc inverse of A
 b +/ .*~ (# }."1 gauss_jordan@(,. idmat@#)) A   NB. solve for x
 jacobi_iteration A;b          NB. solve for x
 gauss_seidel A;b              NB. solve for x
)
