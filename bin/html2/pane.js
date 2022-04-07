// pane

"use strict";

// main = term|edit
// side = edit|term
// view = view (not yet)

var panex;

var mainPane = "<div id='mainpane'><div id='maintop' class='panetop'>" +
 "&nbsp;Term" + "</div><div id='main'></div></div>";

var sidePane = "<div id='sidepane'><div id='sidetop' class='panetop'>" +
 "&nbsp;Edit" + "</div><div id='side'></div></div>";

var viewPane = "<div id='viewpane'><div id='viewtop' class='panetop'>" +
 "&nbsp;View" + "</div><div id='view'></div></div>";

var vBar = "<div id='vb' class='bar fl'></div>"
var hBar = "<div id='hb' class='bar'></div>";

// ---------------------------------------------------------------------
function divsplit(t) {
 return "<div id='splitpane'>" + t + "</div>";
}

// ---------------------------------------------------------------------
function initpanes(t) {
 panex = t;
 var p = getid("panes");
 if (t === 0) {
  p.innerHTML = "<div style='display:flex;'>" +
   mainPane + vBar + divsplit(viewPane + hBar + sidePane) +
   "</div>";
 } else {
  p.innerHTML = "<div style='display:flex;flex-direction:column;'>" +
   divsplit(sidePane + vBar + viewPane) + hBar + mainPane +
   "</div>";
 }
}

// ---------------------------------------------------------------------
function docget(t) {
 return {
  cur: t.getCursor(),
  doc: t.getDoc().copy(true),
  foc: t.hasFocus(),
  scr: t.getScrollInfo()
 };
}

// ---------------------------------------------------------------------
function docset(t, d) {
 var td = t.getDoc()
 t.swapDoc(d.doc);
 t.setCursor(d.cur);
 if (d.foc) t.focus();
}

// ---------------------------------------------------------------------
function swappanes() {
 var edoc = docget(ecm);
 var tdoc = docget(tcm);
 initpanes(1 - panex);
 layout.init();
 initterm();
 initedit();
 docset(ecm, edoc);
 docset(tcm, tdoc);
 resizer();
}
