// localj

"use strict";


var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])
var jgetstr = Module.cwrap('em_jgetstr','string',['string'])

var localjserver = { 
  send: function(cmd, show=false) {
    //don't execute blank links, instead just execute tcmreturn to reset state
    if (cmd.trim()=='') {
      tcmreturn('');
    } else {
      jsetstr('CODE',cmd);      
      var ret = jdo1("(0!:101) CODE");
      //filter out the cmd from the output since it's already been typed in
      ret = ret.replace(cmd,'').trim();
      if (ret.length > 0 && ret[0] == '\n') {
        ret = ret.slice(1);
      }

      //if showing filter out the output_jrx_lines
      if (show == true) {
        ret = ret.split("\n").slice(3).join("\n");
      }

      //generate permalink so the user can copy the executed code
      genPermalink();

      if (ret.length>0) {
        tcmreturn('1'+ ret + '\n');
      } else {
        tcmreturn('');
      }
      
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

