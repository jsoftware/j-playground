// start

"use strict";

var lastfocus;
var popupbox;
var resizetimer;

// ---------------------------------------------------------------------
function initbody() {
 var h = `<div id='tbar'></div>
<div id='panes'></div>
<div id='popupp'><div id='popup'></div></div>`
 document.body.innerHTML = h;
 popupbox = getid("popupp");
}

// ---------------------------------------------------------------------
function initload() {
 initbody();
 inittbar();
 initdlog();
 initmenu();
 initpanes(0);
 layout.init();
 initterm();
 initedit();
 layout.size();
 layout.fini();
 resizer();
 clearterm();
}

// ---------------------------------------------------------------------
function showstate(e) {
 var b = ["mainpane", "maintop", "sidepane", "sidetop", "mn_View",
  "mn_Examples", "mn_EditRun", "mn_context", "mn_nvcontext"
 ];
 if (e)
  b.map(function(x) {
   getid(x).classList.remove("disabled");
  });
 else
  b.map(function(x) {
   getid(x).classList.add("disabled");
  });
 if (tcm)
  tcm.options.readOnly = !e;
}

// ---------------------------------------------------------------------
function resizer() {
 layout.size()
}

// ---------------------------------------------------------------------
window.onkeydown = function(e) {
 if (e.keyCode === 27) // escape
  popupbox.style.display = "none";

 if (e.ctrlKey) {
  if (has("DR", e.key)) {
   e.preventDefault();
  }

  if (e.shiftKey) {
   if (has("", e.key)) {
    e.preventDefault();
   }
  }
 }
}

// ---------------------------------------------------------------------
window.onclick = function(e) {
 if (e.target == popupbox) {
  popupbox.style.display = "none";
 };
}

// ---------------------------------------------------------------------
window.onresize = function() {
 clearTimeout(resizetimer);
 resizetimer = setTimeout(resizer, 150);
}

// ---------------------------------------------------------------------
window.onload = function() {
 initload();
}
