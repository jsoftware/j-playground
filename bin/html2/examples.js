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

load 'viewmat'

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

// ---------------------------------------------------------------------
ExIds.push("Addons");
addexam(`

NB. Addons are packages that can be loaded into a J session

install 'github:jsoftware/math_calculus'

require 'math/calculus'

0 1 2&p. deriv_jcalculus_ 1
`);

ExIds.push("UI");
addexam(`

NB. J Playground has a popup facility that can be used to draw a simple form with user input
NB. the user input can call J code to get html or SVG
NB. In this example, the UI is updated on change of the select. A button could be added instead to refresh the display

POPUPHTML =: 0 : 0
<div>
Select a circle color to draw. The circle will draw on selection<br>
<select id="color" onchange="drawCircle()">
  <option>red</option>
  <option>blue</option>
</select>
</div>
<div id="circle">
</div>
<div style='text-align:right'><button id='popup-ok'>OK</button></div>
)

NB. javascript that is called 
POPUPJS =: 0 : 0
  window.drawCircle = function() {
      var color = document.getElementById('color').value;
      circle.innerHTML = jdo1("getCircle '" + color + "'");
  }
)

NB. example of a j function returning SVG
NB. getCircle 'blue'
getCircle =: 3 : 0
'<svg height="100" width="100"><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="', y, '" /></svg>'
)

NB. initialize JS
(2!:0) POPUPJS

NB. show the popup
(2!:0) 'popup(jgetstr("POPUPHTML"),500,"ok")'

NB. execute some javascript after the popup is displayed to draw the circle
NB. add a delay to let the popup finish rendering
(2!:0) 'setTimeout(function() { drawCircle() },100)'
`);

ExIds.push("CSV");
addexam(`
install 'github:jsoftware/tables_dsv'
install 'github:jsoftware/tables_csv'

require 'tables/csv'

NB. from https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv
NB. read a hard coded csv string
csvtxt =. 0 : 0
date,county,state,fips,cases,deaths,confirmed_cases,confirmed_deaths,probable_cases,probable_deaths
2022-05-27,Autauga,Alabama,01001,15930,216,12757,194,3173,22
2022-05-27,Baldwin,Alabama,01003,56274,682,39319,474,16955,208
2022-05-27,Barbour,Alabama,01005,5694,99,3246,69,2448,30
2022-05-27,Bibb,Alabama,01007,6482,105,4147,73,2335,32
2022-05-27,Blount,Alabama,01009,15055,243,11110,201,3945,42
2022-05-27,Bullock,Alabama,01011,2333,54,1965,43,368,11
2022-05-27,Butler,Alabama,01013,5083,129,4015,96,1068,33
2022-05-27,Calhoun,Alabama,01015,32552,628,22512,468,10040,160
2022-05-27,Chambers,Alabama,01017,8530,162,3711,96,4819,66
2022-05-27,Cherokee,Alabama,01019,5149,86,2891,48,2258,38
2022-05-27,Chilton,Alabama,01021,11155,207,7902,159,3253,48
2022-05-27,Choctaw,Alabama,01023,2052,37,901,17,1151,20
2022-05-27,Clarke,Alabama,01025,7163,101,4705,66,2458,35
2022-05-27,Clay,Alabama,01027,4106,82,2886,66,1220,16
2022-05-27,Cleburne,Alabama,01029,3572,69,2807,46,765,23
2022-05-27,Coffee,Alabama,01031,13724,231,8969,113,4755,118
2022-05-27,Colbert,Alabama,01033,16434,262,10133,213,6301,49
)

subsetdata =. fixcsv csvtxt

NB. show the first 10 lines
10 {. subsetdata

NB. count the lines
# subsetdata

NB. download the full dataset
httpget 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv'
data =: readcsv 'us-counties.csv'

NB. count all the lines
# data

NB. filter to a state
((2{"1 data) = (<'Ohio')) # data
`)
// ---------------------------------------------------------------------
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

