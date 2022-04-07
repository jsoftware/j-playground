// log

"use strict";

var Dlog, DlogMax, DlogPos;

// ---------------------------------------------------------------------
function dlog_add(t) {
 t = t.trim();
 if (t.length === 0) return;
 if (t.includes("\n")) return;
 var p = Dlog.indexOf(t);
 if (p >= 0) Dlog.splice(p, 1);
 if (Dlog.length == DlogMax)
  Dlog.splice(0, 1);
 Dlog.push(t);
 DlogPos = Dlog.length;
 dlog_write();
}

// ---------------------------------------------------------------------
function dlog_clear() {
 Dlog = [];
}

// ---------------------------------------------------------------------
function dlog_scroll(m) {
 var n = Dlog.length;
 if (n == 0) return;
 var p = Math.max(0, Math.min(n - 1, DlogPos + m));
 if (p == DlogPos) return;
 DlogPos = p;
 tcmprompt("   " + Dlog[p]);
}

// ---------------------------------------------------------------------
function dlog_select() {
 var n = Dlog.length;
 if (n == 0)
  return msgbox("No input log");

 var n = Dlog.length;
 var h = `<table id="dlogtop" class="margin0">
 <tr><td>Input Log</td><td style='width:100%'></td>
 <td class='vtop'><div id='popup-close'>&#215;</div>
 </td></tr></table>`
 h += "<select id='dlogsel' size=" + Math.min(20, n) + ">";
 for (var i = 0; i < n; i++)
  h += "<option " + (i === n - 1 ? "selected" : "") + ">" + Dlog[i] + "</option>";
 h += "</select>";
 popup(h, 400);
 getid("dlogtop").style.margin = "0px";
 var s = getid("dlogsel");
 s.focus();
 s.ondblclick = getsel;
 s.onkeypress = function(e) {
  if (e.which == 13) getsel();
 };

 function getsel() {
  var t = s.options[s.selectedIndex].text;
  dlog_selclose();
  tcmprompt("   " + t);
 }

 function dlog_selclose() {
  popupbox.style.display = "none";
  tcm.focus();
 }
}

// ---------------------------------------------------------------------
function dlog_write() {
 localStorage.setItem("dlog", JSON.stringify(Dlog));
}

// ---------------------------------------------------------------------
function initdlog() {
 DlogMax = 100;
 Dlog = JSON.parse(localStorage.getItem("dlog")) || [];
 DlogPos = Dlog.length;
}
