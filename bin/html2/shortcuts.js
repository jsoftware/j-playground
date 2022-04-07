// shortcuts

"use strict";

// ----------------------------------------------------------------------
function shortcuts() {
 function b(t) {
  return "<b>" + t + "</b>";
 }

 function tb(t) {
  return "<tr><td><b>" + t + ":</b></td></tr>";
 }

 function tr(t, v) {
  return "<tr><td>&nbsp;" + t + "</td><td>" + v + "</td></tr>";
 }

 var h = popupheader("&nbsp; Keyboard Shortcuts", false) + "<table id='shortcuts'>";
 h += tb("Focus in Term");
 h += tr("Enter", "Run Line");
 h += tr("Ctrl+Shift+Up", "Scroll Up Log");
 h += tr("Ctrl+Shift+Down", "Scroll Down Log");
 h += tb("Focus in Edit");
 h += tr("Ctrl+Enter", "Run Line");
 h += tr("Ctrl+Shift+Enter", "Run Line Show");
 h += tr("Ctrl+R", "Run All Lines");
 h += tr("Ctrl+Shift+R", "Clear Term and Run All Lines");
 h += tb("Focus in Term or Edit");
 h += tr("F1", "Vocabulary");
 h += tr("Shift+F1", "NuVoc");
 h += tr("Ctrl+F1", "Context-Sensitive");
 h += tr("Ctrl+Shift+F1", "Nuvoc Context-Sensitive");
 h += tr("Ctrl+D", "Input Log");
 h += tr("Ctrl+Shift+C", "Center Panes");
 h += tr("Ctrl+Shift+L", "Flip Panes");
 h += tr("Ctrl+Shift+T", "Clear Term");
 h += "</table>";
 popup(h, 400);
}
