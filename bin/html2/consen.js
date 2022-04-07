// consen

"use strict";

// ---------------------------------------------------------------------
function consen() {

 var h = popupheader("&nbsp; Context Sensitive", false) + `
<p>Context-sensitive help is available for J primitives.</p>

<p>In either window, select the primitive, or put the cursor inside or
to the left of a primitive. Press Ctrl+F1 for the traditional vocabulary
definition, or Ctrl+Shift+F1 for the NuVoc definition. You may need to
allow popups.</p>

<p>For example, with the cursor inside <tt>i.</tt> this will show the
definition of <i>Integers</i>.

<p>Also, in Term, put the cursor spaced out to the left or right
of an expression, then press Ctrl+F1 for J word formation on the line, e.g.</p>

<pre>    2 3 4 +/ i. 5
 ┌─────┬─┬─┬──┬─┐
 │2 3 4│+│/│i.│5│
 └─────┴─┴─┴──┴─┘</pre>`

 popup(h, 600);
 var m = getid("popupd");
}
