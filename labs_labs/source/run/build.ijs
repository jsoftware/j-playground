NB. build

mkdir_j_ jpath '~Addons/labs/labs'

writesourcex_jp_ '~Addons/labs/labs/source/run';'~Addons/labs/labs/lab.ijs'

NB. fix up old labs
dat=. readsourcex_jp_ '~Addons/labs/labs/source/run805'
dat=. dat rplc '''jlab''';'''jlab805'''
dat=. dat rplc '_jlab_';'_jlab805_'
ndx=. 1 i.~'labselrun=:' E. dat
dat=. (ndx{.dat),(ndx}.dat) rplc 'labinit';'lab_jlab_'
dat fwritenew '~Addons/labs/labs/labs805.ijs'

cocurrent 'jpsave'

T=: jpath '~Addons/labs/labs/'
W=: jpath '~addons/labs/labs/'

mkdir_j_ W

f=. 3 : 0
(W,y) (fcopynew ::0:) T,y
)

f each cutopen 0 : 0
exlabs.txt
labdir.ijs
labintro.txt
lab.ijs
labs.ijs
labs805.ijs
)

T=: {."1 dirtree'~addons/*.ijt'
S=: (jpath'~Addons')&, each (# jpath '~addons') }. each T
T fcopynew each S
