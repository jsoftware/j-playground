// main

"use strict";

var AA, BB;
var O = console.log;
var S = JSON.stringify;

// ---------------------------------------------------------------------
var arraysum = e => e.reduce((a, b) => a + b)

// ---------------------------------------------------------------------
function arraysums(s) {
 let t = 0;
 return s.map(e => t += e);
}

// ---------------------------------------------------------------------
function classadd(id, cls) {
 getid(id).classList.add(cls);
}

// ---------------------------------------------------------------------
function classrem(id, cls) {
 getid(id).classList.remove(cls);
}

// ---------------------------------------------------------------------
function closeview() {
 return;
 gridview = plotview = false;
 d3.select("#view").innerHTML = "";
 layout.closeviewer();
}

// ---------------------------------------------------------------------
function cmopen(t, m) {
 var cm = CodeMirror(getid(t), {
  cursorScrollMargin: 18,
  electricChars: false,
  lineWrapping: false,
  mode: m,
  styleActiveLine: true
 });
 return cm;
}

// ---------------------------------------------------------------------
function cmsetsize() {
 ecm.setSize(null, layout.getsideheight());
 tcm.setSize(null, layout.getmainheight());
}

// ----------------------------------------------------------------------
function deb(s) {
 return s.replace(/\s+/g, ' ').replace(/^\s+|\s+$/, '');
}

// ----------------------------------------------------------------------
// delete one blank if at front of string
function dlb1(s) {
 return s[0] === " " ? s.slice(1) : "";
}

// ----------------------------------------------------------------------
// delete trailing blanks
function dtb(s) {
 return s.replace(/\s+$/, '')
}

// ---------------------------------------------------------------------
function dummy() {}

// ---------------------------------------------------------------------
function getclass(e) {
 return document.getElementsByClassName(e);
}

// ---------------------------------------------------------------------
function getdate() {
 return jdo1("9!:14''").split("/")[6];
}

// ---------------------------------------------------------------------
function getheight(e) {
 return e.getBoundingClientRect().height;
}

// ---------------------------------------------------------------------
function getid(e) {
 return document.getElementById(e);
}

// ---------------------------------------------------------------------
function getrect(e) {
 return e.getBoundingClientRect();
}

// ---------------------------------------------------------------------
function getversion() {
 fetch("version.txt")
  .then(e => e.text())
  .then(e => Version = (Number(e) / 1000).toFixed(3));
}

// ---------------------------------------------------------------------
function getviewheight() {
 return layout.getviewheight();
}

// ---------------------------------------------------------------------
function getwidth(e) {
 return e.getBoundingClientRect().width;
}

// ----------------------------------------------------------------------
function has(array, element) {
 return -1 < array.indexOf(element);
}

// ---------------------------------------------------------------------
function hide(e) {
 e.style.display = "none";
}

// ---------------------------------------------------------------------
function quote(s) {
 return "'" + s.replace(/'/g, "''") + "'";
}

// ---------------------------------------------------------------------
function round(n, d) {
 return d * Math.floor(0.5 + n / d);
}

// ---------------------------------------------------------------------
function setheight(e, h) {
 e.style.height = h + "px";
}

// ---------------------------------------------------------------------
function setwidth(e, w) {
 e.style.width = w + "px";
}

// ---------------------------------------------------------------------
function show(e) {
 e.style.display = null;
}

// ---------------------------------------------------------------------
// split on blanks, ignoring J strings 'abc def' and comments
function splitblankJ(s) {
 let t = s.match(/(?:[^\s']+|'[^']*')+/g);
 let n = t.findIndex(e => "NB." === e.substring(0, 3));
 return n === -1 ? t : t.slice(0, n);
}

// ---------------------------------------------------------------------
// J word formation, ignoring comments
function towords(s) {
 let t = jdo1("towords " + quote(s));
 if (t === 0) {
  msgbox("error parsing: " + s);
  return 0;
 }
 t = t.split("\n")
 let n = t.length;
 if (n > 0) {
  if ("NB." === t[n - 1].slice(0, 3))
   t = t.slice(0, n - 1);
 }
 return t;
}

// ---------------------------------------------------------------------
function stringcodes(s) {
 var r = "";
 for (var i = 0; i < s.length; i++)
  r += " " + s.charCodeAt(i);
 return r.substring(1);
}

// ---------------------------------------------------------------------
function tohtml(s) {
 var r = s;
 r = r.replace(/&/g, '&amp;');
 r = r.replace(/"/g, '&quot;');
 r = r.replace(/</g, '&lt;');
 r = r.replace(/>/g, '&gt;');
 r = r.replace(/ /g, '&nbsp;');
 r = r.replace(/\n/g, '<br/>');
 return r;
}
