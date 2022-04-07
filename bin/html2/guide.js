// guide

"use strict";

// ---------------------------------------------------------------------
function guide() {
 var h = popupheader("Playground", true) + `
<p>The Playground runs an interactive J session.</p>

<p>There are two windows: Term, an interactive console, and Edit, a script editor.</p>

<p>In Term:

<ul>
<li>enter an expression and press Enter to run it</li>
<li>move the cursor to any line and press Enter to copy it to the end of the display</li>
<li>For the input log, use Ctrl+Shift up/down cursor keys or Menu View|Input Log</li>
</ul>

<p>In Edit:

<ul>
<li>use the Edit Run menu or corresponding shortcuts to run the lines</li>
<li>click on Edit, hold down Ctrl and press Enter to step through a script</li>
<li>select from the Examples menu to populate the Edit window, or enter your own examples</li>
</ul>

<p>Note: the session RAM is limited to 200MB. This is fine for the examples and most uses,
but exceeding this will end the session. Also, the session will end after 10 minutes inactivity.</p>`

 popup(h, 720);
 var m = getid("popupd");
}
