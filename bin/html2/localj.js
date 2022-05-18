// localj

"use strict";


var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])
var jgetstr = Module.cwrap('em_jgetstr','string',['string'])

var localjserver = { 
  send: function(cmd) { 
    //don't execute blank links, instead just execute tcmreturn to reset state
    if (cmd.trim()=='') {
      //tcmreturn uses the first character to determine how to show the output
      tcmreturn(' ');
    } else {
      jsetstr('CODE',cmd);
      var ret = jdo1("(0!:101) CODE");
      
      //hack to prevent showing ending ) on multi-line definitions... probably needs to be a better way
      if (ret == ')' || ret=='}}')  ret = '';

      //generate permalink so the user can copy the executed code
      genPermalink();

      //tcmreturn slices the first character off
      tcmreturn(' ' + ret + '\n');
    }
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
