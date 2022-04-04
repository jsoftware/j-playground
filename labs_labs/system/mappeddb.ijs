NB. Vehicle Registration (VR) Database
NB. used in lab 'Mapped File Database'
NB. every field has a build... and ...fmt verb
NB. for example,      buildlic and licfmt

require 'data/jmf data/jfiles'

ROWS=:    1e6    NB. 1 million records

GROWTH=:  20          NB. extra records for file size
PATH=:    jpath '~temp/vr/'  NB. path for VR database files
COMFILE=: PATH,'comment'
LICVALS=: '12345ABCDE'
VR=:      'lic';'make';'color';'year';'fine';'firstname';'lastname';'comment'

createdir=: 3 : 'try. 1!:5 <y catch. end.'
and=: *.
seed=: 9!:1  NB. set random seed for reproducible junk data

records=: 3 : 0
i=. y#i.ROWS
'too many records' assert 50>#i
i
)

dbfn=: 3 : 'PATH,y,''.jmf'''

dbcreate=: 3 : 0  NB. size is record byte size
'name size'=. y
unmap_jmf_ name
createjmf_jmf_ (dbfn name);(ROWS+GROWTH)*size
dbmap name
)

dbmap=: 3 : 'map_jmf_ y;dbfn y'

buildlic=: 3 : 0
dbcreate'lic';SZI_jmf_
empty lic=: 1e6+ROWS?.ROWS
)

licfmt=: 3 : 0
<(10 10 10 10 10 10 10#:y{lic){LICVALS
)

liccode=: 3 : '10#.LICVALS i. y'

buildmake=: 3 : 0
MAKES=: ;:'FORD DODGE BUICK PONTIAC HUDSON RAMBLER TOYOTA HONDA ACCURA VW MERCEDES'
n=. #MAKES
(MAKES)=: n{.a.
dbcreate'make';1
seed 123456
empty make=: (?ROWS$n){a.
)

makefmt=: 3 : '<>(a.i.y{make){MAKES'

buildcolor=: 3 : 0
n=. #COLORS=:;:'RED GREEN BLUE GREY PINK YELLOW MAUVE MAROON'
(COLORS)=: n{.a.
dbcreate'color';1
seed 65432
empty color=: (?ROWS$n){a.
)

colorfmt=: 3 : '<>(a.i.y{color){COLORS'

buildyear=: 3 : 0
dbcreate'year';SZI_jmf_
seed 98765
year=: 1900+?ROWS$99
empty''
)

yearfmt=: 3 : '<":,.y{year'

buildfine=: 3 : 0
dbcreate'fine';SZI_jmf_
seed 767652
empty fine=:(?ROWS$5000)*0=100|i.ROWS
)

finefmt=: 3 : '<":,.y{fine'

buildfirstname=: 3 : 0
dbcreate 'firstname';6
empty firstname=: > ROWS$ 6 {.each FIRSTNAME
)

firstnamefmt=: 3 : '<y{firstname'

buildlastname=: 3 : 0
dbcreate 'lastname';8
empty lastname=: > ROWS$ 8 {.each LASTNAME
)

lastnamefmt=: 3 : '<y{lastname'

buildcomment=: 3 : 0
dbcreate'comment';SZI_jmf_
seed 67564
comment=:?ROWS$6
try. jerase COMFILE catch. end.
jcreate COMFILE
empty ('';'com 1';'com 2';'';'scribble 4';'long remark 5') jappend COMFILE
)

commentfmt=: 3 : 0
<>jread COMFILE;y{comment
)

addrecord=: 3 : 0
'xlic xmake xcolor xyear xfine xfirstname xlastname'=.y
lic=:       lic,  liccode xlic
make=:      make, (MAKES i.<xmake){a.
color=:     color,(COLORS i.<xcolor){a.
year=:      year, xyear
fine=:      fine, xfine
firstname=: firstname, 6{.xfirstname
lastname=:  lastname, 8{.xlastname
comment=:   comment, 0
ROWS=: #lic
)

vrmap=:   3 : 'empty dbmap each VR'
vrunmap=: 3 : 'empty unmap_jmf_ each VR'

vrdeleteall=: 3 : 0
vrunmap''
ferase each 1 dir PATH
ferase PATH
empty''
)

FIRSTNAME=: <;._2 (0 : 0)
Alex
Amit
Anne
Boris
Boyd
Bruce
Carlos
Clare
Dale
Darryn
Dianne
Graham
Harlan
Harry
Helen
Jason
Jody
Johny
Julien
Klaus
Lewis
Linda
Lynne
Marc
Margot
Milane
Munroe
Noel
Owen
Pam
Rose
Ross
Shawn
Skip
Tom
Toshio
Troy
Vin
Vince
)

LASTNAME=: <;._2 (0 : 0)
Abbott
Adams
Algar
Anctil
Aqndrews
Beale
Boudreau
Brady
Briscoe
Budd
Cahill
Davis
Dilworth
Donohoe
Downs
Fobear
Foster
Gerow
Glancey
Gordon
Green
Hill
Johnson
Keegan
Keller
Kelly
Kerik
Mcbride
Mckee
Miller
Mills
Newton
Patrick
Patten
Power
Rogerson
Stearn
Sullivan
Tang
Taylor
Thompson
)
