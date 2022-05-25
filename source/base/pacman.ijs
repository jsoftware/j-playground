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
      jsetstr("RESPONSE_httpget_",request.responseText);
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

readpackage=: 3 : 0

'tag rep cmt'=: y

NB. execute the manifest to get the FILES list
(0!:100) <'manifest.ijs'

NB. make the folder for the addon
NB. smoutput 'making ', FOLDER
mkdir (jpath '~addons/',FOLDER)

filesBoxed =. LF cut FILES
urls =. getfileurl each {{tag;rep;cmt;(y,LF)}} each filesBoxed
outputPaths =. {{jpath '~addons/',FOLDER,'/',y}} each filesBoxed
cmds =. urls,.(<"0 (#urls)#100),.outputPaths
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
