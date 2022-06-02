// start

"use strict";

// ---------------------------------------------------------------------
function mbabout() {
 let d = document.createElement("dialog");
 d.id = "about";
 d.classList.add("about");
 d.innerHTML = pdraw();
 document.body.appendChild(d);
 d.showModal();
 d.addEventListener("click", pclose);
 window.addEventListener("keyup", keyup);
}

// -------------------------------------------------------------// ---------------------------------------------------------------------
function pdraw() {
 let msg = `Playground: ${Version}<br/>
Engine: j903/j32/linux<br/>
Build: Wasm/${getdate()}<br/><br/>
Copyright © 2022 Jsoftware Inc.<br/>`
 let icon = `<img src="images/jgreen.png"
style="height:64px;width 64px;margin:0px 20px 0px 5px"/>`;
 let h = `<div style="display:flex;flex:0 0 auto;margin:10px">
<div>${icon}</div><div>${msg}</div></div>
<div class="about-footer">
<button id="ok" class="about-button">OK</button></div>`;
 return h;
}

// ---------------------------------------------------------------------
function pclose() {
 window.removeEventListener("keyup", keyup);
 let id = getid("about");
 if (id) document.body.removeChild(id);
}

// ---------------------------------------------------------------------
function keyup(e) {
 if (e.keyCode === 27 || e.keyCode === 13) return pclose;
}
