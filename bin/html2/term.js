// term

"use strict";

var tcm;
var cmdlist = [];
var widgets = [];

// ---------------------------------------------------------------------
function clearterm() {
 tcm.getDoc().setValue("");
 tcmprompt("   ");
 tcm.focus();
}

// ---------------------------------------------------------------------
function docmd(cmd, log, show) {
 cmd = cmd.trim();
 if (log === undefined)
  log = true;
 if (show === undefined)
  show = false;
 dlog_add(cmd);
 if (log) tcmappend(cmd + "\n");
 if (show)
  localjserver.send("output_jrx_=:i.0 0\noutput_jrx_=:" + cmd + "\noutput_jrx_");
 else
  localjserver.send(cmd);
}

// ---------------------------------------------------------------------
function docmds(cmds, log) {
 cmdlist = cmds.map(function(e) {
  return [e, log, false, true];
 });
 docmdnext();
}

// ---------------------------------------------------------------------
function docmdnext() {
 if (cmdlist.length === 0) return;
 var t = cmdlist.shift();
 if (t.length === 0) {
  tcmappend("\n   ");
  docmdnext();
 } else
  docmdline.apply(null, t);
}

// ---------------------------------------------------------------------
function docmdline(t, g, s, m) {
 var a = isNB(t);
 var b = isNote(t);
 if (!(a || b))
  return docmd(t, g, s);
 if (a) {
  if (m)
   tcmecho(remNB(t));
  else
   docmdline_NB(t);
 } else
  tcmechos(t);
 docmdnext();
}

// ---------------------------------------------------------------------
function docmdline_NB(s) {
 tcmecho(remNB(s));
 var p, t;
 p = ecm.getCursor().line;
 while (p < ecm.lineCount()) {
  t = readentry1(p++)[1];
  if (!isNB(t)) return;
  tcmecho(remNB(t));
  ecm.scrollIntoView(p, 0);
  ecm.setCursor(p, 1e8);
 }
}

// ---------------------------------------------------------------------
function initterm() {
 tcm = cmopen("main");
 /* beautify preserve:start */
 var keys = {
 "Enter": tcmenter,
 "F1": menuvocab,
 "Ctrl-D": dlog_select,
 "Ctrl-R": dummy,
 "Ctrl-Enter": dummy,
 "Ctrl-F1": context,
 "Shift-Ctrl-F1": nvcontext,
 "Shift-F1": menunuvoc,
 "Shift-Ctrl-Down": tcmlogdown,
 "Shift-Ctrl-Up": tcmlogup,
 "Shift-Ctrl-C": layout.centerpanes,
 "Shift-Ctrl-E": layout.toggleedit,
 "Shift-Ctrl-L": swappanes,
 "Shift-Ctrl-T": clearterm,
 "Shift-Ctrl-.": labnext
 };
 /* beautify preserve:end */
 tcm.setOption("extraKeys", keys);
 tcm.on("focus", function() {
  lastfocus = tcm;
 });
 tcmprompt("   ");
}

// ---------------------------------------------------------------------
function tcmaddlinewidget(item) {
 var doc = tcm.getDoc();
 var pos = Math.max(0, tcm.lastLine() - 1);
 var wid = doc.addLineWidget(Math.max(0, tcm.lastLine() - 1), item);
 widgets.push(wid);
}

// ---------------------------------------------------------------------
function tcmappend(t) {
 tcm.setCursor(tcm.lineCount());
 tcm.replaceSelection(t, "end");
}

// ---------------------------------------------------------------------
function tcmecho(s) {
 tcmhtml("<span style='color:green'>" + tohtml(s) + "</span>");
 tcm.setCursor(tcm.lineCount());
}

// ---------------------------------------------------------------------
function tcmechos(t) {
 var s = t.split("\n");
 s = s.slice(1, s.length - 1);
 tcmecho(s.join("\n"));
}

// ---------------------------------------------------------------------
function tcmenter() {
 var n, t;
 n = tcm.getCursor().line
 t = tcm.getLine(n);
 if (n === tcm.lastLine()) {
  tcmappend("\n");
  docmd(t, false);
 } else
  tcmprompt(t);
}

// ---------------------------------------------------------------------
function tcmhtml(e) {
 var div = document.createElement("div");
 div.innerHTML = e;
 document.body.appendChild(div);
 tcmaddlinewidget(div);
}

// ---------------------------------------------------------------------
function tcmlogdown() {
 dlog_scroll(1);
}

// ---------------------------------------------------------------------
function tcmlogup() {
 dlog_scroll(-1);
}

// ---------------------------------------------------------------------
function tcmplot(e) {
 var ndx = e.indexOf("\n");
 var pid = e.slice(0, ndx).split(" ");
 var def = e.slice(ndx + 1);
 var cvs = document.createElement("canvas");
 cvs.id = pid[0];
 cvs.width = pid[1];
 cvs.height = pid[2];
 cvs.position = "absolute";
 document.body.appendChild(cvs);
 tcmaddlinewidget(cvs);
 eval(def);
}

// ---------------------------------------------------------------------
function tcmprompt(t) {
 var n = tcm.lineCount() - 1;
 var len = tcm.getLine(n).length;
 /* beautify preserve:start */
 tcm.getDoc().setSelection({line:n,ch:0}, {line:n,ch:len});
 /* beautify preserve:end */
 tcm.replaceSelection(t);
 tcm.setCursor(tcm.lineCount());
 tcm.scrollIntoView(n, 0)
}

// ---------------------------------------------------------------------
// fixed at 3 spaces
function tcmprompter() {
 tcmprompt("   ");
 docmdnext();
}

// ---------------------------------------------------------------------
function tcmreturn(e) {
 if (e.length) tcmreturn1(e);
 tcmprompter();
}

// ---------------------------------------------------------------------
function tcmreturn1(e) {
 var t = Number(e[0]);
 var s = e.slice(1);
 /* beautify preserve:start */
 switch(t) {
  case 6: return tcmecho(s);
  case 7: return tcmplot(s);
  case 8: return tcmviewmat(s);
  case 9: return showhelp(s);
  case 3: return;
  default: return tcmappend(s);
 }
 /* beautify preserve:end */
}

// ---------------------------------------------------------------------
function tcmviewmat(s) {
 var m = document.createElement("img");
 m.setAttribute("src", "data:image/png;base64," + s);
 document.body.appendChild(m);
 tcmaddlinewidget(m);
}
