NB. math/misc/rsa
NB. Examples of RSA encryption
NB. version: 1.0.1
NB.
NB. method:
NB.   P & Q are primes
NB.   E is exponent, relatively prime to (P-1)*(Q-1)
NB.   D is the inverse of E mod (P-1)*(Q-1)
NB.
NB. here:
NB.     the public key is:  PQ,E   (i.e. a pair of numbers)
NB.     the private key is: D
NB.
NB. then if msg is a list of integers:
NB.   msg (PQ powermod) E   is   encode msg
NB.   msg (PQ powermod) D   is   decode msg
NB.
NB. e.g.
NB.    t2''
NB.    decode encode 233 6728
NB. 233 6728

require 'math/misc/primutil'

NB. =========================================================
NB. example with small values for P and Q
t1=: 3 : 0

P=: 22307x
Q=: 78121x
E=: 46337x
D=: ((P-1) * Q-1) inversep E

PQ=: P*Q
encode=: PQ&|@^&E
decode=: PQ&|@^&D

PQ;E
)

NB. =========================================================
NB. example with big values for P and Q
t2=: 3 : 0

P=: 151 + 10^50x
Q=: 40 + 7^62x
E=: 9 + 10^49x
D=: ((P-1) * Q-1) inversep E

PQ=: P*Q
encode=: PQ&|@^&E
decode=: PQ&|@^&D

PQ;E
)
