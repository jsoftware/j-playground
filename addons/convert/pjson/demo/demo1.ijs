
load 'convert/pjson'

cocurrent 'pjson'

enc 1
enc ,1
enc 1 0 1
enc 4
enc ,4
enc 1 2 3
enc i.2 3
enc ;/i.2 3
enc 'a'
enc ,'a'
enc 'hello'
enc 'one';'two'
enc 'one';<;/i.2 3
enc _ __ _.

dec '[false,3,true]'

f=. ($;<)@dec@enc
f 1
f ,1
f 1 0 1
f 4
f ,4
f 1 2 3
f ;/i.2 3
f 'a'
f ,'a'
f 'hello'
f 'one';'two'
f 'one';<;/i.2 3

dict=: (;:'items sales prices'),.(;:'nut bold cam cog');6 8 0 3;10 20 15 20
enc dict
dec enc dict
dict -: dec enc dict
