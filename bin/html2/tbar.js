// tbar

"use strict";

// ---------------------------------------------------------------------
function inittbar() {
 var h = "<nav id='menu'>";
 var titles = [
  "An Idiosyncratic Introduction to J",
  "A Taste of J",
  "Monad/Dyad",
  "Huffman Coding",
  "Sequential Machines",
  "The Tower of Hanoi",
  "Coleman (sample topics)",
  "Averages",
  "Best Fit",
  "Binomial Coefficients",
  "Families of Functions",
  "Function Tables",
  "Frame's Method",
  "Finite Groups",
  "Iteration and the Power Operator",
  "Mathematical Roots of J",
  "Polynomials",
  "Pythagorean Triples",
  "Shapley Value on Old Macdonald's Farm",
  "Math Tables",
  "Volume",
  "Special Searches"
 ]

 function top(n, w) {
  return '<li' + pid(n) + ' class="top_menu"><a href="#">' + n + '</a><ul class="sub_menu width' + w + '">'
 }

 /* beautify preserve:start */
 function sep(e) {
  if (!e) return "";
  var c = " class='lisep";
  // 1 = underline, 2=space only, 3=both
  switch (e) {
   case 1: return c + 1 + "'";
   case 2: return c + 2 + "'";
   case 3: return c + 1 + " " + c + 2 + "'";}
 }
 /* beautify preserve:end */

 function pid(id) {
  return ' id="mn_' + id.replace(/ /g, "") + '"';
 }

 function sub1(id, n, c) {
  return '<li' + pid(id) + sep(c) + '><a href="#" onclick="menu(\'' + id + '\');">' + n + '</a></li>';
 }

 function sub2(id, n, k, c) {
  return '<li' + pid(id) + sep(c) + '><a href="#" onclick="menu(\'' + id + '\');">' +
   n + '<span style="float:right">' + k + '</span></a></li>';
 }

 h += '<ul class="dropdown" style="float:left">';

 h += top("View", 0);
 h += sub1("clearedit", "Clear Edit", 2);
 h += sub1("clearterm", "Clear Term", 2);
 h += sub1("clearall", "Clear All", 1);
 h += sub2("toggleedit", "Hide/Show Edit", "Shift+Ctrl+E", 1);
 h += sub2("log", "Input Log", "Ctrl+D", 1);
 h += sub2("center", "Center Panes", "Shift+Ctrl+C", 2);
 h += sub2("flip", "Flip Panes", "Shift+Ctrl+L", 1);
 h += "</ul></li>"

 h += top("Examples", 0);
 for (var i = 0; i < Exams.length; i++)
  h += sub1("exam" + i, ExIds[i]);
 //h += sub1("exam" + i, ExIds[i], 1);
 //h += sub1("clearedit", "Clear Edit");
 h += "</ul></li>"

 h += top("Edit Run", 1);
 h += sub2("runline", "Line", "Ctrl+Enter");
 h += sub2("runlineshow", "Line & Show", "Shift+Ctrl+Enter", 1);
 h += sub2("runall", "All Lines", "Ctrl+R", 2);
 h += sub2("runallx", "Clear Term & All Lines", "Shift+Ctrl+R", 2);
 h += "</ul></li>"

 h += top("Labs", 1);
 h += sub2("advlab", "Advance Labs", "Shift+Ctrl+>", 1);
 for (var i = 0; i < labs.length; i++)
  h += sub1("lab" + i, titles[i]);
 h += "</ul></li>"

 h += top("Links", 1);
 h += sub1("plink", "Last Run Permalink", 1);
 h += sub1("wiki", "Wiki", 1);
 h += sub2("nuvoc", "Vocabulary", "F1", 2);
 h += sub2("nvcontext", "Vocabulary Context Sensitive", "Ctrl+F1", 1);
 h += sub1("github", "Jsoftware github", 2);
 h += sub1("download", "Download J", 1);
 h += sub1("teaservideo", "Teaser Video (youtube)", 2)
 h += sub1("rosetta", "Rosetta Code", 1);
 h += "</ul></li>"

 h += top("Help", 1);
 h += sub1("guide", "Playground", 2);
 h += sub1("shortcuts", "Shortcuts", 2);
 h += sub1("consen", "Context Sensitive", 1);
 //h += sub1("about", "About", 2);

 h += "</ul></li>"
 h += "</ul></nav>"

 getid("tbar").innerHTML = h;
}
