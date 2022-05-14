// examples

var Exams = [];
var ExIds = [];

// ---------------------------------------------------------------------
function addexam(t) {
 Exams.push(t.trim() + "\n");
}

// ---------------------------------------------------------------------
ExIds.push("First Steps");
addexam(`
;/i.2 3 4

?~10
t=: ?~10
t

NB. single line comment
NB.    another single line comment

Note ''
multiline
comment
)

NB. verb definition
foo=: 3 : 0
a=. 2 + y
5 * a
)

foo 1 2 3

load 'stats'
dstat normalrand 1000

load 'plot'
plot p:i.5
`);

// ---------------------------------------------------------------------
ExIds.push("Structural");
addexam(`

t=: 10*i.6                     NB. numeric list

<\\ t                           NB. prefixes
+/\\ t                          NB. sum each prefix
+/\\. t                         NB. sum each suffix

0 1 0 2 1 0 </. 10*i.6         NB. group by key

[M=: 10 * i.3 4                NB. matrix

100 200 300 + M                NB. add to each row

100 200 300 400 +"1 M          NB. add to each col (add by row)

|: M                           NB. transpose

</.M                           NB. oblique lines

2 2 <;._3 M                    NB. 2x2 sub matrices

[t=: 'earl of chatham'         NB. string  examples
(# ; ~. ; |. ; 2&# ; 3#,:) t
;: t                           NB. word formation

sort &. ;: t                   NB. sort words

(toupper@{.,}.) each &. ;: t   NB. capitalize each word

`);

// ---------------------------------------------------------------------
ExIds.push("Arithmetic");
addexam(`

- 3                      NB. Negation (monadic)
2 - 3                    NB. Subtraction (dyadic)

% 3                      NB. Reciprocal
2 % 3                    NB. Division

^ 0 1 2                  NB. Exponential
2 ^ 3                    NB. Power

2 3 5 */ 10 20 30        NB. times table

*/~ _2 + i.7             NB. times self table

tab=. /~                 NB. self table function

(];*.tab;!tab) i.7       NB. arg;LCM;combinations

% 1 + i.7x               NB. x is rational/extended precision

2r3 ^ 50x

[p=. ?.~8                NB. random permutation

p { 'abcdefgh'           NB. x{y indexes y by x

p { p                    NB. permute (i.e. index) p by p

{ /\\ 6 8$p               NB. identity after 6 permutes

C.p                      NB. cycles of permutation

*./ #&> C. p             NB. LCM of cycle lengths is order of p

`);


// ---------------------------------------------------------------------
ExIds.push("Plot");
addexam(`

NB. plot is a graphics package designed for interactive use at the
NB. terminal, where most graphics options are inferred from the data.

load 'numeric plot'

plot dat=: (sin,:cos)^steps _1 2 100

NB. options may be given in the left argument
'key sin(exp),cos(exp);pensize 5' plot dat

NB. data shown in 2d and 3d:
plot dat=: sin@*/~ i:2j50
'surface' plot dat

NB. the pd function is the low-level plot driver:
pd 'multi 1,1 2 3'
pd  '';"1 |:(i.6) ^/ 1 + 0.2 * i.3
pd 'show'

`);

// ---------------------------------------------------------------------
ExIds.push("Viewmat");
addexam(`

NB. load 'viewmat'

viewmat */~ i:3                NB. multiplication table

viewmat (i.!4) A. 'ABCD'       NB. complete permutation table of order 4

copy=: ,,.~
copy ,1
copy copy ,1
(Navy,:Yellow) viewmat copy ^:8 ,1   NB. Sierpinski triangle

y=: 3&#. inverse i.243
(Yellow,Blue,:Olive) viewmat y +./ . *. |: y  NB. and carpet

HP=: 0, 0 1 0 ,: 0       NB. initial data for Peano curve
NB. single step:
hp=: 3 : '(|.,]) 1 (0 _2 _2 ,&.> _2 _1 0 + #y) } (,.|:) y'
scale=: [ # #"1          NB. scale y by integer x
viewrgb 2 scale (hp ^:6 HP) { 256 #. Purple,:Lime

`);


var labs =[
    'core/intro',
    'core/jtaste2',
    'core/monad',
    'general/huffman',
    'general/seqmachine',
    'general/towerofhanoi',
    'livetexts/coleman',
    'math/averages',
    'math/bestfit',
    'math/bincoefs',
    'math/families',
    'math/fntab',
    'math/frame',
    'math/groups',
    'math/iter',
    'math/mathroot',
    'math/polynom',
    'math/pythag3',
    'math/shapley',
    'math/tables',
    'math/volume',
    'system/special_searches',
    ]

    //'core/display',
    //'core/sparse',

