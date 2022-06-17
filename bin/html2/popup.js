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
 var button = getid(b);
 if (button) { 
     button.onclick = function() {
    p.style.display = "none";
    };
 }
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

// ---------------------------------------------------------------------
function progresspopup() {
    if (!getid("popup"))
     document.body.innerHTML = "<div id='popupp'><div id='popup'></div></div>";
    var h = '<table><tr><td><img src="images/loading.gif"><td><textarea id="progress-output" style="border:none;outline:none;width:380px;height:200px"></textarea></td></tr></table>'
    h += "<div style='text-align:right'><button id='popup-ok'>OK</button></div>";

    /*
    window.out = function(text) {        
        console.log(text);
        var output = document.getElementById("progress-output");
        if (!output) { return; }
        output.value +=  text + "\n";
        output.scroll({ top: element.scrollHeight, behavior: 'smooth' });
 
    }*/

    console.log = (function (old_function, div_log) { 
        return function (text) {
            old_function(text);
            if (!div_log) { return; }
            div_log.value +=  text + "\n";
            div_log.scroll({ top: div_log.scrollHeight, behavior: 'smooth' });
    
        };
    } (console.log.bind(console), document.getElementById("progress-output")));

    popup(h, 450, "ok");
   }
   