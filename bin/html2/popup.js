// popup

"use strict";

// ----------------------------------------------------------------------
function msgbox(msg) {
 if (!getid("popup"))
  document.body.innerHTML = "<div id='popupp'><div id='popup'></div></div>";
 var h = "<p>" + msg + "</p>";
 h += "<div style='text-align:right'><button id='popup-ok'>OK</button></div>";
 popup(h, 300, "ok");
}

// ---------------------------------------------------------------------
function popup(h, w, t) {
 var p = getid("popupp");
 var m = getid("popup");
 m.style.width = w + "px";
 m.innerHTML = h;
 p.style.display = "block";
 var top = Math.max(10, (getheight(document.body) - getheight(m) - 50) / 2);
 p.style.paddingTop = top + "px";
 var b = "popup-" + ((t === "ok") ? "ok" : "close");
 getid(b).onclick = function() {
  p.style.display = "none";
 };
}

// ---------------------------------------------------------------------
function popupheader(title, icon) {
 var h = '<table><tr><td>';
 if (icon)
  h += '<img src="images/jgreen.png" /></td><td>'
 h += title + `</td><td style='width:100%'></td>
<td style="vertical-align:top;padding-right:5px">
<div id='popup-close'>&#215;</div></td>
</tr></table><hr>`;
 return h;
}
