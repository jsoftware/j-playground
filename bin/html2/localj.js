// localj

"use strict";


var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])
var jgetstr = Module.cwrap('em_jgetstr','string',['string'])

//override window.out to output to the terminal
window.out = function(str) {
  tcmreturn(' ' + str + '\n');
}

var localjserver = {
  sendMultiple: function(cmds) {
    jsetstr('CODE',cmds.join("\n"));
    jdo1("(0!:101) CODE");
    //generate permalink so the user can copy the executed code
    genPermalink();

  },
  send: function(cmd) { 
    //if the cmd has a linefeed in it, it should be executed with (0!:101) because jdo expects single lines
    //no output is required since window.out is overridden
    if (cmd.indexOf("\n")>-1) {
      jsetstr('CODE',cmd);
      jdo1("(0!:101) CODE");
    } else 
      jdo1(cmd)
  }
} 

function genPermalink() {
  document.getElementById("mn_plink").childNodes[0].href = '#code='+encodeURIComponent(ecmget())
    //replace parentheses as they cause problems in markdown
    .replace(/\(/g, '%28').replace(/\)/g, '%29');;
}

function checkPermalink() {
  var code = decodeURIComponent(window.location.hash).substr(1);
  if (code.substring(0,5)=='code=') {
    code = code.substring(5);
    ecmset(code);
  } 
  else if (code.toLowerCase().substring(0,4) == 'url=') {
      let url = code.substring(4);
      console.log(url);
      fetch(url).then(response=>response.text()).then(data=>{ 
          ecmset(data);
      });    
  }
}


// ---------------------------------------------------------------------
// originally this connected to a docker instance
// now just does the load ...
function connect() {
  initload();
}
