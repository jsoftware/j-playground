NB. build
NB.
NB. copies labs over to addons

S=: jpath '~Addons/labs/labs'
T=: jpath '~addons/labs/labs'
fixdir=: T , (#S) }. ]
mkdir_j_ &> fixdir each dirpath S

SF=: {."1 dirtree S
TF=: fixdir each SF
TF fcopynew each SF
