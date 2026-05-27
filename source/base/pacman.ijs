NB. =========================================================
NB. support for pacman (WIP)

cocurrent 'jpacman'

httpgetJS=: {{)n
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

NB. =========================================================
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

NB. =========================================================
NB. extracts a path from a path with filename
getPath=: 3 : 0
'/' , y #~ +./\. y e. '=/'
)

NB. =========================================================
NB. replacement for pacman version
readpackage=: 3 : 0

'tag rep cmt'=: y

NB. make the folder for the addon
mkdir jpath '~addons/',FOLDER

filesBoxed=. FILES
urls=. getfileurl each {{tag;rep;cmt;(y,LF)}} each filesBoxed
outputPaths=. {{jpath '~addons/',FOLDER,'/',y}} each filesBoxed
cmds=. urls,.(<"0 (#urls)#100),.outputPaths

NB. make any subdirectories
mkdir_jpacman_ each ~. getPath each outputPaths

NB. download each file
httpget each <"1 cmds
)

NB. =========================================================
httpget=: 3 : 0
'f t p'=. 3 {. (boxxopen y),a:
URL_httpget_=: f
(2!:1) httpgetJS
n=. f #~ -. +./\. f e. '=/'
if. 0=#p do. p=. jpath '~temp/',n end.
RESPONSE_httpget_ (1!:2) <p
0;n
)

NB. =========================================================
NB. override install to only support github for now
install_z_=: 3 : 0
install_gitrepo_jpacman_ y
)

NB. =========================================================
NB. create a helper httpget in z
httpget_z_=: 3 : 0
httpget_jpacman_ y
)

NB. =========================================================
openscriptJS=: 0 : 0
 ecm.getDoc().setValue(jgetstr("RESPONSE_httpget_"));
 ecm.setCursor(0,1e8);
 ecm.focus();
)

NB. =========================================================
NB. open a script on github
openscript=: 3 : 0
httpget y;3;''
(2!:1) openscriptJS
)

openscript_z_=: openscript_jpacman_
