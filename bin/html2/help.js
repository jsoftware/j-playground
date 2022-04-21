// help

// ---------------------------------------------------------------------
function context() {
 getcontext(0);
}

// ---------------------------------------------------------------------
function nvcontext() {
 getcontext(1);
}

// ---------------------------------------------------------------------
// get dic, class, position and text
function getcontext(t) {
 let cm, cls, bgn, end, txt;
 cm = lastfocus;
 txt = cm.getDoc().getSelection();
 if (txt.length) {
  bgn = 0;
  end = txt.length;
 } else {
  let doc = cm.getDoc();
  let cur = doc.getCursor()
  txt = doc.getLine(cur.line);
  bgn = end = cur.ch;
 }
 if (!txt.trim()) return tcm.focus();
 txt = t + " " + ((cm === tcm) ? 0 : 1) + " " + bgn + " " + end + " " + txt;
 let cmd = "helpplay_jws_ '" + txt + "'"
 localjserver.send(cmd);
}

// ---------------------------------------------------------------------
function showhelp(s) {
 var t = Number(s[0]);
 s = s.substring(1);
 if (t === 0) {
  var p = tcm.getCursor().line;
  var n = tcm.lineCount() - 1;
  if (n === p)
   tcmappend("\n");
  else {
   var len = tcm.getLine(n).length;
   tcm.getDoc().setSelection({
    line: p + 1,
    ch: 0
   }, {
    line: n,
    ch: len
   });
   tcm.replaceSelection("");
  }
  return tcmappend(s);
 }
 if ("nuvoc" === s.substring(0, 5))
  return menuwiki("Vocabulary" + s.substring(5));
 return menuhelp(s);
}
