NB. stats/base/multivariate
NB. Multivariate statistics

NB.*XtY            sum of cross products (monadic is XtX)
NB.*spdev v        sum of cross products of deviations
NB. cov v          (co)variance or var/cov matrix
NB.*covp v         population (co)variance or var/cov matrix
NB.
NB.*diag v         returns the matrix diagonal
NB.*cov2cor v      convert var/cov matrix to correlation matrix
NB. corr v         correlation or correlation matrix
NB.
NB. lsfit v        least-squares fit
NB. regression v   multiple regression

require '~addons/stats/base/univariate.ijs'
cocurrent 'z'

XtY=: +/ .*~ |:           NB. sum of cross products (monadic is XtX)
spdev=: XtY&dev           NB. sum of cross products of deviations

NB. =========================================================
NB.*cov v Covariance or variance/covariance matrix
NB. form: [x] cov y
NB. y is: numeric list or matrix
NB. x is: numeric list or matrix
NB. Monadic use:
NB.   if y is a numeric list, the variance of the list is returned.
NB.   if y is a numeric matrix, the variance/covariance matrix of the columns is returned
NB. Dyadic use:
NB.   if x and y are numeric lists then the covariance of the 2 lists is returned
NB.   if x and y are compatible matrices, the variance/covariance matrix of their columns is returned
cov=: spdev % <:@#@]

NB. "p" suffix = population definitions
covp=: spdev % #@]       NB. population (co)variance or var/cov matrix

diag=: (<0 1)&|:          NB. returns matrix diagonal
cov2cor=: % */~@:%:@diag  NB. convert var/cov matrix to correlation matrix

NB. =========================================================
NB.*corr v Correlation or correlation matrix
NB. form: [x] corr y
NB. Arguments as per cov, but returns correlations or correlation matrix
NB. Although dyadic form also works for modadic matrix arguments, it is not as numerically exact
corr=: cov2cor@cov : (cov % */~&stddev)

NB. =========================================================
NB.*rankcorr v Spearman rank correlation or correlation matrix
NB. form: [x] rankcorr y
NB. Arguments as per corr, but returns rank correlations or rank correlation matrix
rankcorr=: corr&(/: rankFractional"_1&.|:)

NB.*interpolate v  simple linear interpolation for intermediate points
NB.y is: X,:Y  lists of X and corresponding Y values
NB.x is: XI    list of points XI to interpolate Y for, to return YI
NB.EG: (1.1 * i.8) interpolate (i.10) ,: (1.1 ^~ i.10)
NB. http://www.jsoftware.com/pipermail/programming/2008-June/011078.html
NB. https://code.jsoftware.com/wiki/Phrases/Arith#Interpolation
interpolate=: 4 : 0
  ix =. 1 >. (<:{:$y) <. (0{y) I. x
  intpoly =. (1 { y) ,. (,~ {.)   %~/ 2 -/\"1 y
  (ix { intpoly) p. ((<0;ix) { y) -~ x
)

NB. =========================================================
NB.*lsfit v least-squares fit
NB. form: n lsfit xy
NB. coefficients of polynomial fitting data points
NB. using least squares approximation.
NB. xy = 2 row matrix of x ,: y
NB. n  = order of polynomial
lsfit=: {:@] %. {.@] ^/ i.@>:@[

NB. =========================================================
NB.*regression v multiple regression
NB. form:  independent regression dependent
NB.    dependent = vector of n observations (Y value)
NB.  independent = n by p matrix of n observations for p independent
NB.                variables (X value)
NB.
NB. returns: formatted values
regression=: 4 : 0
v=. 1,.x
d=. y
b=. d %. v
k=. <:{:$v
n=. $d
sst=. +/*:d-(+/d) % #d
sse=. +/*:d-v +/ .* b
mse=. sse%n->:k
seb=. %:({.mse)*(<0 1)|:%.(|:v) +/ .* v
ssr=. sst-sse
msr=. ssr%k
rsq=. ssr%sst
F=. msr%mse

r=. ,: '             Var.       Coeff.         S.E.           t'
r=. r, 15 15j5 15j5 12j2 ": (i.>:k),.b,.seb,.b%seb
r=. r, ' '
r=. r, '  Source     D.F.        S.S.          M.S.           F'
r=. r, 'Regression', 5 15j5 15j5 12j2 ": k, ssr,msr,F
r=. r, 'Error     ', 5 15j5 15j5 ": (n-k+1), sse,mse
r=. r, 'Total     ', 5 15j5 ": (n-1), sst
r=. r, ' '
r=. r, 'S.E. of estimate    ', 12j5 ":%:mse
r=. r, 'Corr. coeff. squared', 12j5 ": rsq
)
