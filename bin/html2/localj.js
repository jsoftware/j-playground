// localj

"use strict";


var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])
var jgetstr = Module.cwrap('em_jgetstr','string',['string'])

var localjserver = { 
  send: function(cmd) { 
    //console.log(cmd);    
    jsetstr('CODE',cmd);
    var ret = jdo1("(0!:101) CODE");
    
    //hack to prevent showing ending ) on multi-line definitions... probably needs to be a better way
    if (ret == ')' || ret=='}}')  ret = '';

    //tcmreturn slices the first character off
    tcmreturn(' ' + ret + '\n');
  }
} 



// ---------------------------------------------------------------------
// originally this connected to a docker instance
// now just does the load ...
function connect() {
  initload();
}
