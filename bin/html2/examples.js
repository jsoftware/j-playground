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

plot dat=: +/~ sin i:12j50

sombrero0=: [: (1&o. % ]) [: %: [: +/~ *:
   
'surface' plot sombrero0 i:12j99

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

ExIds.push("Neural Network");
addexam(`
NB. Neural Network Demo (from https://gist.github.com/jpjacobs/6ff68c07bf764ad886e097ffbd19f5f0)
NB. (roughly based on chapters 1-3 of http://neuralnetworksanddeeplearning.com/ by Michael Nielsen)
NB. The main differences with the book are:
NB. - the removal of the minibatch function and loops in favor of matrix functions
NB. - joining bias and weight calculations.

NB. SHOWPROGRESS=1 experimental support to show progress dialog

NB. *** Preparations ***
NB. install addons needed from github for reading CSV files
{{install^:(-.fexist'~addons/tables/',y)'github:jsoftware/tables_',y}}&>;:'dsv csv'
NB. require the needed addons
require 'tables/csv plot viewmat stats/base'
NB. Onehot and back (inverse)
onehot_z_   =: (0 1 (#"1)~ 1,.~ ]) :. (i.&1"1)
NB. split train/test data: x : number of random samples to take as test;
splitdat =: [ |.@split ({~ ?~@#)@]

NB. *** Data download & preprocessing ***
httpget^:(-.fexist'~temp/spirals.csv')'https://raw.githubusercontent.com/reisanar/datasets/master/spiral.csv'
num  =: (/: {:"1) ".&> }. readcsv '~temp/spiral.csv' NB. read data; discard column headers
data =: <: +: (%"1 >./)@(-"1 <./) }:"1 num NB. normalised: _1 < data < 1
labs =: onehot <: {:"1 num                 NB. labels one-hot encoded
jit  =:  15%~normalrand ($data), 3         NB. data jitter to be added 3x
datext=: ,/ 0 2 1|: data + jit             NB. new dataset with 3x jittered data
labext=: 3 # labs                          NB. corresponding labels

NB. *** Neural network class ***
cocurrent 'nn' NB. wrap in a J class.
destroy =: codestroy     NB. to discard a network, do destroy__obj ''
sig   =: %@:>:@:^@:-     NB. sigmoid activation; note @: vs. @ makes enormous difference
dsig  =: (* -.)@:sig     NB. d sig(y) / d y (note: scalar)
loss  =: (+/)@:-:@:*:@:- NB. Quadratic loss; assume features in rows.
dLoss =: -~              NB. gradient of loss
mpb =: +/ .* 1 , ]       NB. biased matrix product

NB. Create object; called by conew; could be used to re-initialise weights.
NB. takes y: array of layer sizes, from input (=#feature dims) to output (=#~.labels)
create =: {{
  sizes  =: y 
  bw     =: ([: <@normalrand@|. 1 0&+)"1]   2 ]\\ sizes NB. bias ,. weight arrays.
  repint =: 1000         NB. reporting every repint epochs in sgd training
  0 0 $ histloss =:2 0$0 NB. keeps training & test loss
}}
NB. Forward pass; assumes features in rows; returns labels with classes in rows
fwd =: {{for_p. bw do. y =. sig (>p) mpb y end.}}
pred =: fwd&.:|: NB. shortcut for operating on instances in rows

NB. Stochastic Gradient Descent.
NB. x takes #epochs, batch size and learning rate;
NB.  if batchsize = _, it performs back prop on the tentire dataset.
NB. y is training data or training data;testing data (for display only).
NB. Data arrays have instances in rows, and columns are: features,. labels.
NB. The numbers of label columns are derived from sizes__obj.
sgd =: {{
  'ep bs lr' =. x                       NB. epochs, batch size and learning rate
  'tr ts'  =. 2 {. boxopen y            NB. split training and test data (if present)
  tr=. ({~ ?~@#) tr                     NB. random shuffle training data
  'fttr lbtr' =. ({.sizes) split |: tr  NB. first {. sizes rows deemed to be labels
  'ftts lbts' =. ({.sizes) split |: ts  NB. the same for testing data
  losstr =. lossts =. ep$0              NB. for keeping training loss statistics
  for_e. i. ep do.                      NB. repeat for all episodes
    (-bs) lr&backprop\\ tr               NB.   do BP per batch of max batch size
    NB. Do forward pass to compute and record loss for stats.
                losstr =. losstr e}~ lltr=. (+/%#) lbtr loss fwd fttr
    if. #ts do. NB. the same for testing data if present.
      lossts =. lossts e}~ llts=. (+/%#) lbts loss fwd ftts end.
    if. 0=repint|e do.                  NB. echo state at each repint interval
        if. #ts do. echo 'Epoch complete: ',(":e),' losses: ',(": lltr,llts)
        else.       echo 'Epoch complete: ',(":e),' loss: '  ,(": lltr) end.
    end.
  end.
  0 0 $ histloss=: histloss,.losstr,:lossts NB. append losses
}}

NB. Backpropagation to update biases & weights
NB. x: learning rate
NB. y: data ,. labels (rows = instances, # columns for labels derived from sizes.
backprop =: {{
  'act lab' =. ({.sizes) split |: y  NB. y: inst x ft -> ft x inst 
  NB. ---Foward pass---
  zs =. 0 $ as =. <act NB. keep z and activations; first activation is input data.
  delta =. ($bw) $ a:  NB. very similar to fwd above, but will keep zs 
  for_p. bw do.        NB. and as for each layer for backward pass.
    act =. sig z =. (>p) mpb act NB. activations and z's for layer
    as  =. as,<act     NB. store them for reuse in backward pass 
    zs  =. zs,<z
  end.
  NB. ---Backward pass---
  last=.1                 NB. for triggering special treatment of output layer as first factor
  for_L. |.i.<:#sizes do. NB. for all layers, going backwards (|.)
    if. last do.          NB. first factor f1 in err depends on whether the layer is last or not.
      last=.0 [ f1 =. lab dLoss _1 {:: as NB. last, so get loss w.r.t. last activations
    else. f1=. (|: }."1 > bw {~ L+1) +/ .* err end. NB. else, update from previous err(L+1)
    err   =. f1 * dsig L {:: zs                     NB. error, i.e. small delta in the URL above                   
    delta =. delta L}~ < err +/ .* |: 1,L {:: as    NB. get update multiplying error with activation, 1 for bias
  end.
  bs =. #{.y                      NB. batch size for normalization
  bw =: bw (- bs %~ x&*)&.> delta NB. update bw__obj for each layer
}}
nn_z_ =: conew&'nn' NB. shortcut function for creation.

NB. Report results on data, taken as y=boxed training/test data split
report =: {{
  echo 'NN training report'
  'dtr ltr'=. ({.sizes) split|: 0{:: y NB. split training in data and labels
  'dts lts'=. ({.sizes) split|: 1{:: y NB. Same for testing data
  NB. data plots
  pd 'reset'
  pd 'sub 1 2'
  pd 'new'
  pd 'type marker; aspect 1; title #Training = ',":{:$ltr
  pd&> ;/@|:&.> dtr (</.~ #.)&|: ltr
  pd 'use'
  pd 'type marker; aspect 1; title #Testing = ',":{:$lts
  pd&> ;/@|:&.> dts (</.~ #.)&|: lts
  pd 'endsub'
  pd 'show'
  NB. Return accuracies on training and testing data and confusion matrix
  echo 'training accuracy (%)   : ',": 100*(+/%#) *./ ltr=prtr =. (="1 >./) fwd dtr
  echo 'testing  accuracy (%)   : ',": 100*(+/%#) *./ lts=prts =. (="1 >./) fwd dts
  echo 'confusion matrices training; testing' NB. convert labels into indices into matrix, add all possible label combo's, <:@#/. , reshape KxK  
  echo conf =. (ltr;lts) ([: ($~ ,~@%:@#) [: <:@#/.~  (,~ ,/@:>@{@,~@:<@~.@,)@/:~@ ,.&(onehot inv@|:) ) each prtr;prts
  NB. Show training / testing loss evolution plot.
  'title Loss;xcaption epoch; key train test;keypos rti' plot histloss
  echo 'decision boundary' NB. shows RGB for classes, the brighter/more pure/crisper, the better, NOTE: works only for 3 classes, since it uses RGB 
  viewrgb (,~@>: |.@|:@$  256 #. 255 <.@:* [: (%"1 >./)@:(-"1 <./) [: pred [: ,/@:>@{@,~@:<@i: 1+j.) 300
  NB. entropy of predicted labels: higher entropy = higher uncertainty = decision boundary
  'density; mesh 0;aspect 1' plot (,~@>: $ [: -@:(+/"1@:(*^.)) [: (%"1 >./)@:(-"1 <./) [: pred [: ,/@:>@{@,~@:<@i: 1+j.) 300
}}
cocurrent 'base'

NB. Fix funky errors preventing larger jviewmat pictures:
enclength_jzlib_=: 3 : 0
ix=. <: +/({:"1 lz_length)<:y
code=. 257 + ix
ex=. y-(<ix,1){lz_length
assert. (0<:ex)*.(300>:ex) NB. upped limit here.
code, 1000+ex
)

NB. Create neural network. First and last neuron count should be 2 and 3, respectively,
NB.   for matching data dimensionality and label count 
net =: nn 2 15 8 3
5000 _ 0.1 sgd__net spl =: 300 splitdat datext ,. labext
report__net spl
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

