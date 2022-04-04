NB. build

S=. jpath '~Addons/math/misc/'
T=. jpath '~addons/math/misc/'
SF=. 1 dir S,'*.ijs'
TF=. (T,(#S)}.]) each SF
TF fcopynew each SF