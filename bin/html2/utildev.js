// utildev

"use strict";

var AA, BB, CC, DD;

// ---------------------------------------------------------------------
var O = console.log;

function OA(a) {
 return a.map(O)
}

// ----------------------------------------------------------------------
function jsoncopy(v) {
 return JSON.parse(JSON.stringify(v));
}

// ---------------------------------------------------------------------
// timing in milliseconds
// overhead is ~ 0.05ms
// also console.time("id"), console.timeEnd("id");
function timex(exp, reps) {
 if (reps === undefined) reps = 1;
 var t1 = performance.now();
 for (var i = 0; i < reps; i++)
  eval(exp);
 var t2 = performance.now();
 var s = (t2 - t1).toFixed(3);
 console.log(s);
}

// ---------------------------------------------------------------------
function exammer() {
 return;
 if ("cdbacer" !== Config.host) return;
 Exams.unshift(`
load 'plot numeric'

2+3

plot dat=: (sin,:cos)^steps _1 2 100

i.5`);

 ExIds.unshift("plotter");

 Exams.unshift(`
2 + _3

NB. comment
A=: ?~10
A

i.5`);

 ExIds.unshift("runner");
}

exammer();
