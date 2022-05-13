// main

"use strict";

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

// ---------------------------------------------------------------------
function dummy() {}

// ---------------------------------------------------------------------
function getclass(e) {
 return document.getElementsByClassName(e);
}

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

// ----------------------------------------------------------------------
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
// split on blanks, ignoring J strings 'abc def'
function splitblankJ(s) {
 return s.match(/(?:[^\s']+|'[^']*')+/g);
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
