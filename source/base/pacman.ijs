NB. ===================================================
NB. support for pacman (WIP)

cocurrent 'jpacman'

httpgetJS =: {{)n
    let url = jgetstr("URL_httpget_");
    var request = new XMLHttpRequest();
    request.open('GET', url, false);
    request.send(null);
    console.log(url);
    if (request.status === 200) {
      //console.log(request.responseText);
      //this fails on a large file
      //jsetstr("RESPONSE_httpget_",request.responseText);

      //from https://github.com/emscripten-core/emscripten/issues/6860
      var bufferSize = Module.lengthBytesUTF8(request.responseText);
      var bufferPtr = Module._malloc(bufferSize + 1);
      Module.stringToUTF8(request.responseText, bufferPtr, bufferSize + 1);

      jsetstrPtr("RESPONSE_httpget_",bufferPtr);
    }


}}

getfileurl=: 3 : 0
'tag rep cmt file'=. y
select. tag
case. 'github' do.
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  sub=. ;2 }. p
  'https://raw.githubusercontent.com/',rpo,cmt,'/',sub,file
case. do.
  ''
end.
)

NB. extracts a path from a path with filename
getPath =: 3 : 0
'/' , y #~ +./\. y e. '=/'
)

readpackage =: 3 : 0

'tag rep cmt'=: y

NB. execute the manifest to get the FILES list
(0!:100) <'manifest.ijs'

NB. make the folder for the addon
mkdir (jpath '~addons/',FOLDER)

filesBoxed =. LF cut FILES
urls =. getfileurl each {{tag;rep;cmt;(y,LF)}} each filesBoxed
outputPaths =. {{jpath '~addons/',FOLDER,'/',y}} each filesBoxed
cmds =. urls,.(<"0 (#urls)#100),.outputPaths

NB. make any subdirectories
mkdir_jpacman_ each ~. getPath each outputPaths

NB. download each file
httpget each <"1 cmds
)

httpget =: 3 : 0
'f t p'=. 3 {. (boxxopen y),a:
URL_httpget_ =: f
(2!:0) httpgetJS
n=. f #~ -. +./\. f e. '=/'
if. 0=#p do. p=. jpath '~temp/',n end.
RESPONSE_httpget_ (1!:2) <p
0;n
)

NB. override install to only support github for now
install_z_ =: 3 : 0
  install_gitrepo_jpacman_ y
)

NB. create a helper httpget in z
httpget_z_ =: 3 : 0
  httpget_jpacman_ y
)

openscriptJS=: 0 : 0
 ecm.getDoc().setValue(jgetstr("RESPONSE_httpget_"));
 ecm.setCursor(0,1e8);
 ecm.focus();
)

NB. open a script on github
openscript=: 3 : 0
 httpget y;3;''
 (2!:0) openscriptJS
)

openscript_z_=: openscript_jpacman_
