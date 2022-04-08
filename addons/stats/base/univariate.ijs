NB. stats/base/univariate
NB. Univariate statistics

NB.*mean v         arithmetic mean (dyadic: weighted)
NB.*geomean v      geometric mean
NB.*harmean v      harmonic mean
NB.*commonmean v   common mean
NB.
NB.*dev v          deviation from mean (dyadic: weighted)
NB.*ssdev v        sum of squared deviations (dyadic: weighted)
NB.*var v          sample variance (dyadic: weighted)
NB.*stddev v       standard deviation (dyadic: weighted)
NB.*varp v         population variance
NB.*stddevp v      population standard deviation
NB.*skewness v     skewness
NB.*kurtosis v     kurtosis
NB.
NB.*min v          minimum
NB.*max v          maximum
NB.*midpt v        index of midpoint
NB.*median v       median
NB.
NB. quantiles v    quantiles of y at the specified probabilities x
NB. nquantiles v   values which partition y into x quantiles
NB. iqr v          interquartile range (IQR) of y
NB. ntiles v       assign values of y to x quantiles
NB. cile v         assign values of y to x subsets of nearly equal size
NB.
NB. dstat v        descriptive statistics
NB. freqcount v    frequency count
NB. Idotr v        equivalent to I. but intervals closed on left, open on right
NB. histogram v    histogram
NB. binnedData a   applies u to binned data y as specified by intervals x

cocurrent 'z'

mean=: (+/ % #) : wmean        NB. arithmetic mean (dyadic: weighted)
geomean=: mean &.: ^.          NB. geometric mean
harmean=: mean &.: %           NB. harmonic mean
commonmean=: [: {. (%:@*/ , -:@+/) ^: _

wmean=: +/@[ %~ +/@:*          NB. weighted arithmetic mean
wdev=: ] -"_1 _ wmean          NB. weighted deviation from mean
wssdev=: [ +/@:* *:@wdev       NB. weighted sum of squared deviations
wvar=: (#@-.&0 %~ <:@#@-.&0 * +/)@[ %~ wssdev  NB. weighted sample variance
wstddev=: %:@wvar              NB. weighted sample standard deviation

dev=: (-"_1 _ mean) : wdev     NB. deviation from mean (dyadic: weighted)
ssdev=: (+/@:*:@dev) : wssdev  NB. sum of squared deviations (dyadic: weighted)
var=: (ssdev % <:@#) : wvar    NB. sample variance (dyadic: weighted)
stddev=: (%:@var) : wstddev    NB. sample standard deviation (dyadic: weighted)

NB. "p" suffix = population definitions
varp=: ssdev % #               NB. population variance
stddevp=: %: @ varp            NB. population standard deviation

min=: <./
max=: >./
midpt=: -:@<:@#
median=: -:@(+/)@((<. , >.)@midpt { /:~)

NB. There are a number of different methods for calculating quantiles
NB. https://en.wikipedia.org/wiki/Quantile , also Hyndman and Fan (1996)
qh4=. 4 : 'x * # y'               NB. alpha=0, beta=1
qh5=. 4 : '0.5 + x * # y'         NB. alpha=0.5, beta=0.5
qh6=. 4 : 'x * >:@# y'            NB. alpha=0, beta=0
qh7=. 4 : '1 + x * <:@# y'        NB. alpha=1, beta=1      ; default for R, NumPy & Julia
qh8=. 4 : '1r3 + x * 1r3 + # y'   NB. alpha=1/3, beta=1/3  ; recommended by Hyndman and Fan (1996)
qh9=. 4 : '3r8 + x * 0.25 + # y'  NB. alpha=3/8, beta=3/8  ; tends to be used for Normal QQ plots
Qh=: (qh4 f.)`(qh5 f.)`(qh6 f.)`(qh7 f.)`(qh8 f.)`(qh9 f.)
QuantileMethod=: 7               NB. default quantile method to use

NB. =========================================================
NB.*quantiles v  returns the quantile of y at the specified probabilities x
NB. y is: numeric values to calculate quantiles for
NB. x is: 0{:: probabilities at which to calculate quantiles (default 0.25 0.5 0.75)
NB.       1{:: method for calculating quantiles (default 7)
NB. EG: 0 0.25 0.5 0.75 1 quantiles 2 4 5 6 7 8 9
quantiles=: 3 : 0
  0.25 0.5 0.75 quantiles y
:
  t=. /:~ y
  'prob htype'=. 2 {. (boxopen x) ,< QuantileMethod
  'invalid quantile method' assert (3&< *. <&10) htype
  qh=. (Qh {~ htype - 4)`:6    NB. define quantile method
  h=. (,prob) <:@qh t          NB. J is zero-based so subtract 1
  h=. 0 >. (<:@#t) <. h        NB. constrain h between 0 & n-1
  diff=. t -/@({~ >. ,: <.) h
  prop=. (] - <.) h
  base=. t ({~ <.) h
  base + prop * diff
)

NB. =========================================================
NB.*nquantiles v  returns the values which partition y into x quantiles
NB. returns 1 less value than the number of quantiles specified
NB. y is: numeric values to calculate quantiles for
NB. x is: number of quantiles (default 4)
NB. EG: 4 nquantiles 2 4 5 6 7 8 9
nquantiles=: 4&$: : ((}.@i. * %)@[ quantiles ])

NB.*iqr v  calculates the interquartile range (IQR) of y
iqr=: -/@(0.75 0.25 quantiles ])

NB. =========================================================
NB.*ntiles v  assign values of y to x quantiles
NB. x is: number of quantiles (default 4)
NB. EG: 2 ntiles 2 4 5 6 7 8 9
ntiles=: 4&$: : (] Idotr~ min@] , nquantiles , >:@max@])

NB. =========================================================
NB.*cile v  assign values of y to x subsets of nearly equal size
NB. eg: 3 cile i.12
cile=: $@] $ ((* <.@:% #@]) /:@/:@,)

NB.*rankOrdinal a  ordinal ranking ("0 1 2 3") of array y
NB. tied items are ranked on the order they appear in y
NB. eg: /: rankOrdinal 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankOrdinal 5 2 5 0 6 2 4  NB. rank descending
rankOrdinal=: 1 :'/:@u'

NB.*rankCompete a  standard competition ranking ("0 0 2 3") of array y
NB. eg: /: rankCompete 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankCompete 5 2 5 0 6 2 4  NB. rank descending
rankCompete=: 1 :'u~ i. ]'

NB.*rankDense a  dense ranking ("0 0 1 2") of array y
NB. eg: /: rankDense 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankDense 5 2 5 0 6 2 4  NB. rank descending
rankDense=: 1 :'u rankOrdinal@~. {~ ~. i. ]'

NB.*rankFractional a  fractional ranking ("0 1.5 1.5 3") of array y
NB. Items with the same ranking have the mean of their ordinal ranks.
NB. eg: /: rankFractional 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankFractional 5 2 5 0 6 2 4  NB. rank descending
rankFractional=: 1 : '(] (+/ % #)/. u rankOrdinal) {~ ~. i. ]'

NB. =========================================================
NB.*dstat v  descriptive statistics
NB. table of formatted descriptive statistics
dstat=: 3 : 0
t=. '/sample size/minimum/maximum/median/mean'
t=. t,'/std devn/skewness/kurtosis'
t=. ,&':  ' ;._1 t
v=. $,min,max,median,mean,stddev,skewness,kurtosis
t,. ": ,. v y
)

NB. =========================================================
NB.*freqcount v  frequency count
NB. (value, frequency) sorted by decreasing frequency
freqcount=: (\: {:"1)@(({. , #)/.~)

NB. =========================================================
NB.*Idotr v  Equivalent to I. but intervals are closed on the left and open on the right
NB. Idotr : (0{x) <= y < (1{x)
NB.    I. : (0{x) < y <= (1{x)
Idotr=: |.@[ (#@[ - I.) ]

NB. =========================================================
NB.*histogram v  tally of the items in each bin
NB. x is a list of interval start/end points. The number of intervals is 1+#x
NB. y is an array of data
histogramR=: <: @ (#/.~) @ (i.@>:@#@[ , I.)      NB. Intervals (,]
histogramL=: <: @ (#/.~) @ (i.@>:@#@[ , Idotr)   NB. Intervals [,)
histogram=: histogramL f.

NB. =========================================================
NB.*binnedData a  Applies verb u to the values of y after binning them in the intervals specified by x
NB. x is a list of interval start/end points. The number of intervals is 1+#x
NB. y is an array of data.
NB. eg: < binnedData  NB. verb to box the binned data
NB. eg: (+/ % #) binnedData  NB. verb to average the binned data
binnedData=: adverb define
  bidx=. i.@>:@# x                    NB. indicies of bins
  x (Idotr (u@}./.)&(bidx&,) ]) y     NB. apply u to data in bins after dropping first value
)

NB. =========================================================
NB.*kurtosis v  4th moment coefficient
kurtosis=: # * +/@(^&4)@dev % *:@ssdev

NB. =========================================================
NB.*skewness v  3rd moment coefficient
skewness=: %:@# * +/@(^&3)@dev % ^&1.5@ssdev
