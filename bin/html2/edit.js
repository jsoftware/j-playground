// code

"use strict";

var ecm;
var ecmLast;

// ---------------------------------------------------------------------
function clearedit() {
 ecm.getDoc().setValue("");
 ecm.focus();
}

// ---------------------------------------------------------------------
// multiline direct definition begin
// result is count of multiline defs started
// this for single lines only, not surrounding lines
function dirdef_begin(s) {
 if (!s.includes("{{")) return 0;
 let t = towords(s);
 if (t === 0) return 0;
 let b = t.map(e => e === "{{")
 let n = b.findIndex(e => e);
 if (n === -1) return 0;
 let e = t.map((e, i) => e === "}}" && i > n);
 return Math.max(0, arraysum(b) - arraysum(e));
}

// ---------------------------------------------------------------------
// multiline direct definition end
// result is count of multiline defs ended
// same note as dirdef_begin
function dirdef_end(s) {
 if (!s.includes("}}")) return 0;
 let t = towords(s);
 if (t === 0) return 0;
 let b = t.reduce((a, b) => a + (b === "{{"), 0);
 let e = t.reduce((a, b) => a + (b === "}}"), 0);
 return e - b;
}

// ---------------------------------------------------------------------
function ecminitvalue() {
 if (ecmLast)
  ecm.setValue(ecmLast);
 else
  ecm.setValue(Exams[0]);

 checkPermalink();
}

// ---------------------------------------------------------------------
function ecmrunall() {
 ecmsnap();
 docmds(readall(), true);
}

// ---------------------------------------------------------------------
function ecmrunallx() {
 clearterm();
 ecmrunall();
}

// ---------------------------------------------------------------------
function ecmrunline() {
 ecmrunline_do(true, false);
}

// ---------------------------------------------------------------------
function ecmrunlineshow() {
 ecmrunline_do(true, true);
}

// ---------------------------------------------------------------------
// log, show
function ecmrunline_do(g, s) {
 ecmsnap();
 docmdline(readentry(), g, s);
}

// ---------------------------------------------------------------------
function ecmset(s) {
 ecm.getDoc().setValue(s);
 ecm.focus();
}

// ---------------------------------------------------------------------
function ecmget() {
 return ecm.getDoc().getValue();
}

// ---------------------------------------------------------------------
function ecmsnap() {
 ecmLast = ecm.getDoc().getValue();
}

// ---------------------------------------------------------------------
function editlast() {
 if (ecmLast) {
  ecm.getDoc().setValue(ecmLast);
  ecm.focus();
 }
}

// ---------------------------------------------------------------------
function editclose() {
 layout.editorclose();
}

// ---------------------------------------------------------------------
function editopen() {
 ecm.refresh();
 ecm.focus();
}

// ----------------------------------------------------------------------
function getline(p) {
 if (p >= ecm.lineCount()) return undefined;
 return ecm.getLine(p).replace("\r", "").replace("\t", " ");
};

// ---------------------------------------------------------------------
function initedit() {
 ecm = cmopen("side", "j");

 /* beautify preserve:start */
 var keys = {
 "F1": menuvocab,
 "Ctrl-D": dlog_select,
 "Ctrl-R": ecmrunall,
 "Ctrl-Enter": ecmrunline,
 "Ctrl-F1": context,
 "Shift-Ctrl-F1": nvcontext,
 "Shift-Ctrl-T": clearterm,
 "Shift-F1": menunuvoc,
 "Shift-Ctrl-Down": dummy,
 "Shift-Ctrl-Up": dummy,
 "Shift-Ctrl-C": layout.centerpanes,
 "Shift-Ctrl-E": layout.toggleedit,
 "Shift-Ctrl-L": swappanes,
 "Shift-Ctrl-R": ecmrunallx,
 "Shift-Ctrl-Enter": ecmrunlineshow,
 "Shift-Ctrl-.": labnext
 };
 /* beautify preserve:end */

 ecm.setOption("extraKeys", keys);
 ecm.setOption("matchBrackets", true);
 ecm.on("focus", function() {
  lastfocus = ecm;
 });

 ecminitvalue();
}

// ----------------------------------------------------------------------
// return if line is start of multiline definition
// checks only most common cases using standard library
// not multiline direct definition
function ismultiline(t) {
 var s = t.trim();
 if (s.length === 0) return false;
 if ("Note'" === s.substring(0, 5)) return true;
 s = towords(s);
 if (s === 0) return 0;
 if ("Note" === s[0]) return true;
 var len = s.length;
 var num = ["0", "1", "2", "3", "4"];
 var def = ["noun", "adverb", "conjunction", "verb", "monad", "dyad"];
 for (var i = 1; i < len; i++) {
  if (s[i] !== "define" &&
   (s[i] !== ":" || i === len - 1 || s[i + 1] !== "0")) continue;
  if (has(def, s[i - 1]) || has(num, s[i - 1])) return true;
 }
 return false;
}

// ----------------------------------------------------------------------
function isNB(e) {
 return "NB." === e.trim().substring(0, 3);
}

// ----------------------------------------------------------------------
// Note or unassigned multiline noun explicit definition
function isNote(t) {
 var s = t.trim();
 if (s.length === 0) return false;
 if ("Note'" === s.substring(0, 5)) return true;
 var s = splitblankJ(s);
 if (s.length < 2) return false;
 if (s[0] === "Note") return true;
 if (!(s[0] === "0" || s[0] === "noun")) return false;
 return s[1] === "define" || (s[1] === ":" && s[2] === ":");
}

// ----------------------------------------------------------------------
// returns next entry from current position
function readentry() {
 var r = readentry1(ecm.getCursor().line);
 ecm.scrollIntoView(r[0], 0);
 ecm.setCursor(r[0], 1e8);
 return r[1];
}

// ----------------------------------------------------------------------
// returns next line, entry from given position
function readentry1(p) {
 let r = getline(p++);
 let s = r.trim();
 if (s.length === 0) return [p, s];
 let max = ecm.lineCount();

 // comments
 if ("NB." === s.substring(0, 3)) {
  while (p < max) {
   let t = getline(p).trim();
   if ("NB." !== t.substring(0, 3)) break;
   s += "\n" + dlb1(t.slice(3));
   p++;
  }
  return [p, s];
 }

 // direct definitions
 let n = dirdef_begin(r);
 if (n) {
  while (p < max) {
   let t = getline(p++);
   r += "\n" + t
   n = n - dirdef_end(t);
   if (n <= 0) break;
   if (p === max) r += " }}";
  }
  return [p, r];
 }

 // explicit definitions
 if (!ismultiline(r)) return [p, r];
 while (p < max) {
  var t = getline(p++);
  r += "\n" + t;
  if (t === ")") break;
  if (p === max) r += "\n)";
 }

 return [p, r];
};

// ----------------------------------------------------------------------
function readall() {
 var p = 0;
 var r = [];
 var s;
 while (p < ecm.lineCount()) {
  s = readentry1(p);
  p = s[0];
  r.push(s[1]);
 }
 return r;
}

// ----------------------------------------------------------------------
function remNB(s) {
 s = s.substring(3 + s.indexOf("NB."));
 if (" " === s.substring(0, 1))
  s = s.substring(1);
 return s;
}
