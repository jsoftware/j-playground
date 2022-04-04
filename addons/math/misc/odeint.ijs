NB. math/misc/odeint
NB. Solve initial value ordinary differential equations
NB. version: 1.0.0
NB.
NB. contributed by David Lambert

Note 'Runge Kutta differential equation integrator'
 The dyad   u Odeint  is an adaptive verb to solve
 initial value ordinary differential equations
 returning at the end of the step XY;nok;nbad;maxerr
 When it works, XY is x_end, y at x_end
 Upon identifying a problem, XY is a literal message.

 Use: GERUND stepper Odeint ARG
 u is the stepper that advances the solution one step.
 Verbs of the gerund x compute the derivatives,
 The boxed y supplies (x0,y0);x_end;(err,htry,hmin)

 Each of the derivatives are evaluated as dyads,
 x being the value of the independent variable,
 and y being the estimated function values at x.

 Example of simple differential equation:
 (Using the mathematica notation I recall)
 D[y[x],x] == - x*y  we write as ff=: 4 : '- x * y'
 (or tacitly as ff=: (*-) )
 In this case we need a scalar gerund.
 Hence the gerund of derivatives is  ({.ff`!)
 The left argument to u Odeint is: ({.ff`'')
 The right argument: (x0,y0);x_end;(err,htry,hmin)
 e.g.  ARG=. (0 10);1;(1e_8,0.05,1e_8)
 See the pendulum example in the test verb to use Odeint.

 This file provides three steppers
  rkck_step   Cash-Karp coefficients
  rkf45_step  Runge-Kutta-Fehlberg 45 coefficients
  rkdp_step   Dormand–Prince
 as well as a conjunction Stepper to generate
 other stepper verbs given the Butcher Tableau.
 The stepper dyad accepts as x the derivatives gerund, and as y:
 'XY0 DYDX0 H' =. y
 H is the independent interval size,
 XY0 and DYDX0 are the values at the start of the interval.
 The stepper returns a vector of 2 boxes containing
 XY at the end of the interval, and in the tail box
 are error estimates. (XY0 + (H , DY0)) ; DY0 - DY1

 Odeint code stems from the Numerical Recipes odeint program.
 The returned values nok, nbad and errmax are
 the numbers of accepted and rejected steps, and the
 maximum error amongst the solution variables.

 Solutions at a grid of positions are useful, but alas,
 this version of Odeint does not store the solution on
 or near a grid.  The example verb
 low_amplitude_pendulum_of_given_period
 accomplishes this.
)

float=: _1&x:
mp =: +/ .*

NB. Model of FORTRAN "SIGN(A,B)" function:
F_sign=: (* |)~ (1 _2 p. 0&>)

Odeint=: adverb define
:
 NB. stepper=. u
 DERIVATIVES =. x
 'xy0 x2 param'=. y
 'eps h1 hmin'=. param
 x=. x1=. {. xy=. xy0
 tiny=. 1e_30
 maxstp=. 10000
 h=. h1 F_sign x2-x1
 'nstp nok nbad maxerr' =. 0
 while. (nstp=. >:nstp) <: maxstp do.
  dydx=. ({. DERIVATIVES`:0 }.) xy
  yscal=. (|}.xy)+(|h*dydx)+tiny
  if. 0 < (x+h-x2)*(x+h-x1) do. h=. x2-x end.
  'xy hdid hnext maxerr'=. DERIVATIVES u Rkqs xy;dydx;h;eps;yscal
  x=. {. xy
  if. 0(* ::1:)x do. xy;nok;nbad;maxerr return. end. NB. error test
  if. hdid = h do. nok=. >: nok else. nbad=. >: nbad end.
  if. 0 <: (x-x2)*(x2-x1) do. xy;(nok,nbad,maxerr) return. end.
  if. hmin > | hnext do.
   'Stepsize smaller than minimum in Odeint.';nok;nbad;maxerr
   return.
  end.
  h=. hnext
 end.
 'Too many steps in Odeint.';nok;nbad;maxerr
)

Rkqs=: adverb define
:
 NB. stepper=. u
 DERIVATIVES=. x
 'safety pgrow pshrink errcon'=. 0.9 _0.2 _0.25 1.89e_4
 'xy dydx h eps yscal'=. y
 whilst. 1 do.
  'xynew yerr'=. DERIVATIVES u xy;dydx;h
  errmax=: >./ | yerr%yscal*eps
  if. errmax <: 1 do. break. end.
  h=. h * 0.1 >. safety*errmax^pshrink
  xnew=. h + {. xy
  if. xnew = {. xy do. 'Step too small!';h;hnext;errmax return. end.
 end.
 hnext =. h * 5:^:(errmax <: errcon) safety*errmax^pgrow
 xynew;h;hnext;errmax
)

Note 'Stepper conjunction'
 The coefficients A and B are from the Butcher Tableau
 shown in 2014 MAY wikipedia entries
 http://en.wikipedia.org/wiki/List_of_Runge-Kutta_methods

 For instance, the Butcher tableau for RKF45 is

  0
  1/4   1/4
  3/8   3/32      9/32
  12/13 1932/2197 -7200/2197 7296/2197
  1     439/216   -8         3680/513   -845/4104
  1/2   -8/27     2          -3544/2565 1859/4104 -11/40

  16/135  0 6656/12825 28561/56430 -9/50 2/55
  25/216  0 1408/2565  2197/4104   -1/5  0

 Below, please find how these are used with Stepper
 to create the rkf45 stepper verb.


 Present A as m, B as n .  A Stepper B results creates a verb
 that advances the solution one explicit Runge-Kutta step.

 To the resulting stepper verb,
 x is a gerund to compute derivatives.
 y are the function values.

 In turn, the stepper invokes verbs f of the gerund as
 X f FUNCTION_VALUES
 X is the independent variable.
)

Stepper =: conjunction define
:
 'XY0 DYDX0 H' =. y
 C =. float +/"1 m
 'B0 B1' =. n
 A =. float m
 a =. A&({~ [: < (; i.@>:))
 T =. ({. XY0) + H * C
 Y =. }. XY0
 k =. [ , H * (T {~ ]) (x`:0) Y + (mp~ a)
 K =. > k&.>~/ (;/i.-#A) , < ,:  H * DYDX0
 DY0 =. B0 mp K
 DY1 =. B1 mp K
 (XY0 + (H , DY0)) ; DY0 - DY1
)

Note'order of the coefficients B'
 The first row of coefficients determine the integration result.
 The second row determine the error as the difference in estimates
 first row - that of the second row
)

NB. Cash-Karp coefficients
A=: ,:,1r5
A=: A,3r40 9r40
A=: A,3r10 _9r10 6r5
A=: A,_11r54 5r2 _70r27 35r27
A_RKCK=: A,1631r55296 175r512 575r13824 44275r110592 253r4096

B=: 37r378 0 250r621     125r594     0 512r1771
B_RKCK=: B ,: 2825r27648 0 18575r48384 13525r55296 277r14336 1r4

NB. Runge-Kutta-Fehlberg 45 coefficients
A=: ,:,1r4
A=: A,3r32 9r32
A=: A,1932r2197 _7200r2197 7296r2197
A=: A,439r216 _8 3680r513 _845r4104
A_RKF45=: A,_8r27 2 _3544r2565 1859r4104 _11r40

B=: 16r135 0 6656r12825 28561r56430 _9r50 2r55
B_RKF45=: B,:25r216 0 1408r2565 2197r4104 _1r5 0

NB. Dormand–Prince
A=: ,:,1r5
A=: A,3r40 9r40
A=: A,44r45 _56r15 32r9
A=: A,19372r6561 _25360r2187 64448r6561 _212r729
A=: A,9017r3168 _355r33 46732r5247 49r176 _5103r18656
A_RKDP=: A,35r384 0 500r1113 125r192 _2187r6784 11r84
B=: 5179r57600 0 7571r16695 393r640 _92097r339200 187r2100 1r40
B_RKDP=: B,:35r384 0 500r1113 125r192 _2187r6784 11r84 0

rkck_step =: A_RKCK Stepper B_RKCK
rkf45_step =: A_RKF45 Stepper B_RKF45
rkdp_step =: A_RKDP Stepper B_RKDP

low_amplitude_pendulum_of_given_period =: monad define
 NB. in mathematica notation, as I recall...
 NB. DSolve[D[angle[t],{t,2}]+k Sin[angle[t] == 0, {angle[t],0,10}]
 NB.  /. {k->y^2, angle[0]->0.01, D[angle[t],t][0]->0}
 TAU =. 2p1 NB. tauday.com
 PERIOD =. y
 ANGULAR_FREQUENCY =. TAU % PERIOD
 PENDULUM =. {:@:]`([: - (*: ANGULAR_FREQUENCY) * 1 o. {.@:])
 GRID =. 10(*(%~i.@>:))100
 H =. >./ | 2-/\ y
 f =. ],PENDULUM 0&{::@:(rkck_step Odeint) ({.@:] ; ;&(1e_8,H,1e_4)@:[)
 >f&.>/(;/|.GRID),<,:0 0.01 0
)

test =: monad define NB. nilad
 NB. solutions match www.mcise.uri.edu/.../Pendulum Example.pdf
 PENDULUM =. {:@:]`([: - (19.62) * 1 o. {.@:])
 I0=. 0 1r3p1 0
 TF=. 5
 Y =. I0 ; TF ; 1e_8 0.05 1e_4
 A =.      0{::PENDULUM rkck_step Odeint Y
 A =. A ,: 0{::PENDULUM rkf45_step Odeint Y
 A =. A ,  0{::PENDULUM rkdp_step Odeint Y
 assert *./ 1e_4 > , | 5 _0.2304 _4.3108 (-"1) A
)
