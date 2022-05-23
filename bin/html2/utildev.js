// utildev

"use strict";

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
