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
 if ("lab" === t.substring(0, 3))
  return labrun(labs[Number(t.substring(3))]);
 if (window[t])
  return window[t]();
 switch (t) {
  case "center":
   return layout.centerpanes();
  case "consen":
   return menuwiki("Playground#Context_Sensitive");
  case "constants":
   return menuwiki("Vocabulary/Constants");
  case "controls":
   return menuwiki("Vocabulary/ControlStructures");
  //case "dictionary":
   //return menuhelp("dictionary/contents");
  case "flip":
   return swappanes();
  case "guide":
   return menuwiki("Playground");
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
  case "shortcuts":
   return menuwiki("Playground/Shortcuts");
  case "toggleedit":
   return layout.toggleedit();
  case "wiki":
   return menuwiki("");
  //case "vocab":
   //return menuhelp("dictionary/vocabul");
  case "plink":
    return menuplink();
  case "advlab":
    labnext();
 }
}

// ---------------------------------------------------------------------
function menuconsen() {
 menu("consen");
}

// ---------------------------------------------------------------------
function menuguide() {
 menu("guide");
}

// ---------------------------------------------------------------------
//function menuhelp(t) {
 //return window.open("https://www.jsoftware.com/docs/help807/" + t + ".htm", "_blank");
//}

// ---------------------------------------------------------------------
function menuref() {
 menu("ref");
}

// ---------------------------------------------------------------------
function menunuvoc() {
 menu("nuvoc");
}

// ---------------------------------------------------------------------
function menushortcuts() {
 menu("shortcuts");
}

// ---------------------------------------------------------------------
function menuvocab() {
 menu("vocab");
}

// ---------------------------------------------------------------------
function menuwiki(t) {
 return window.open("https://code.jsoftware.com/wiki/" + t, "_blank");
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

// ---------------------------------------------------------------------
function labrun(labPath) {

  //load the labs utilities / doesn't hurt to reload each time
  jdo1("(0!:0) <'labs/labs805.ijs'")
  var lab = labPath.slice(labPath.indexOf('/')+1);
  var lines  = jdo1("lab 'labs/" + lab + ".ijt'");
  lines.split('\n').forEach(line=>{
    tcmappend(line+"\n");
  })

  //go back to the base locale so the labs execute where the user can interact
  jdo1("('base';'z') copath 'jlab805'")

  return 0;

}

// ---------------------------------------------------------------------
function labnext() {
  var lines = jdo1("labnext''")
  lines.split('\n').forEach(line=>{
    tcmappend(line+"\n");
  })


}
