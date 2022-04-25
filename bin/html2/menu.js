// menu

"use strict";

var topmenu;

// ---------------------------------------------------------------------
function initmenu() {
 topmenu = getid("menu").querySelectorAll(".top_menu");
 for (let i = 0; i < topmenu.length; i++) {
  topmenu[i].addEventListener("mouseover", menuopen);
  topmenu[i].addEventListener("mouseout", menuclose);
 }
}

// ---------------------------------------------------------------------
function menu(t) {
 menucloseall();
 if ("exam" === t.substring(0, 4))
  return ecmset(Exams[Number(t.substring(4))]);
 if (window[t])
  return window[t]();
 switch (t) {
  case "center":
   return layout.centerpanes();
  case "constants":
   return menuwiki("Vocabulary/Constants");
  case "controls":
   return menuhelp("dictionary/ctrl");
  case "dictionary":
   return menuhelp("dictionary/contents");
  case "flip":
   return swappanes();
  case "log":
   return dlog_select();
  case "nuvoc":
   return menuwiki("NuVoc");
  case "runline":
   return ecmrunline();
  case "runlineshow":
   return ecmrunlineshow();
  case "runall":
   return ecmrunall();
  case "runallx":
   return ecmrunallx();
  case "wiki":
   return menuwiki("");
  case "vocab":
   return menuhelp("dictionary/vocabul");
  case "plink":
    return menuplink();
 }
}

// ---------------------------------------------------------------------
function menuhelp(t) {
 return window.open("http://www.jsoftware.com/docs/help807/" + t + ".htm", "_blank");
}

// ---------------------------------------------------------------------
function menuref() {
 menu("ref");
}

// ---------------------------------------------------------------------
function menunuvoc() {
 menu("nuvoc");
}

// ---------------------------------------------------------------------
function menuvocab() {
 menu("vocab");
}

// ---------------------------------------------------------------------
function menuwiki(t) {
 return window.open("http://code.jsoftware.com/wiki/" + t, "_blank");
}

// ---------------------------------------------------------------------
function menuplink(t) {
  var url = document.getElementById("mn_plink").childNodes[0].href;
  return window.open(url, "_blank");
 }

 
// ---------------------------------------------------------------------
function menuclose() {
 menuclose1(this);
}

// ---------------------------------------------------------------------
function menuclose1(e) {
 e.getElementsByTagName("ul")[0].style.display = "none";
}

// ---------------------------------------------------------------------
function menucloseall() {
 topmenu.forEach(menuclose1);
}

// ---------------------------------------------------------------------
function menuopen() {
 this.getElementsByTagName("ul")[0].style.display = "block";
}

// ---------------------------------------------------------------------
function about() {
 var h = popupheader("Playground", true) + "<p>Version 1.01</p>";
 if (!!jver) {
  var v = jver.substring(1).split("/");
  h += "<p>" + v[0] + " " + v[1].substring(1) + "-bit " + v[2]; // + " " + v[3];
  h += "<br/>" + v[6] + "</p>";
 }
 h += "<hr><p>&copy; 2018 Jsoftware</p>";
 popup(h, 200);
}
