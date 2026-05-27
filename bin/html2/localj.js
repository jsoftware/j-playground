// localj
//
// window defs here match those in the original playground localj.js

import createModule from "./jamalgam.js";

// ---------------------------------------------------------------------
async function main() {
 window.Module = await createModule({});

 console.log("Module ready!");

 let rc = Module.cwrap("em_jinit", "int", "void")();
 if (rc !== 0) return alert("Could not load J engine");
 window.jdo1 = Module.cwrap("em_jdo", "string", ["string"]);
 window.jgetstr = Module.cwrap("em_jgetstr", "string", ["string"]);
 window.jsetstr = Module.cwrap("em_jsetstr", "void", ["string", "string"]);
 window.jsetstrPtr = Module.cwrap("em_jsetstr", "void", ["string", "int"]);

 window.localjserver = {
  send: function (cmd, show = false) {
   if (cmd.trim() == "") {
    tcmreturn("");
   } else {
    jsetstr("CODE_jrx_", cmd);
    var ret = jdo1("(0!:101) CODE_jrx_");

    //if show filter out the output_jrx_lines
    //else filter out the cmd from the output
    if (show) {
     let n = ret.indexOf("output_jrx_\n");
     ret = n === -1 ? "" : ret.slice(12 + n);
    } else {
     ret = ret.replace(cmd, "");
     ret = ret.slice(1 + ret.indexOf("\n"));
    }

    //generate permalink so the user can copy the executed code
    genPermalink();

    if (ret.length > 0) {
     tcmreturn("1" + ret + "\n");
    } else {
     tcmreturn("");
    }
   }
  }
 };

 jdo1("(0!:0) <'../jlibrary/system/main/stdlib.ijs'");
 jdo1("(0!:0) <'../jlibrary/bin/emj.ijs'");
 window.JVersion = jdo1("9!:14''").split("/")[0];
}

// === Calling exported C functions ===

// Direct call (if you exported with _ prefix)
//if (typeof Module._myFunction === "function") {
//const result = Module._myFunction(42);
//console.log("Result from C:", result);
//}

// Using ccall / cwrap (recommended for safety)
//const myFunc = Module.cwrap("myFunction", "number", ["number"]);
//console.log("Result via cwrap:", myFunc(100));

// Or one-off call
//const sum = Module.ccall("add", "number", ["number", "number"], [5, 7]);
//console.log("5 + 7 =", sum);

// ---------------------------------------------------------------------
main().catch(console.error);
