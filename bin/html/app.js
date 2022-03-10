var outputDiv = document.createElement('div')
document.body.appendChild(outputDiv)

var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])

function getLine(textarea) {
    //console.log("getting stuff");
    let v = textarea.value;
    let start = 0, end = v.length;
    for (let i = textarea.selectionStart; i < v.length; i++) {
        if (v[i] == '\n') { end = i + 1 ; break; }
    }
    for (let i = textarea.selectionStart - 1; i >=0 ; i--) {
        if (v[i] == '\n') { start = i + 1; break; }
    }

    return v.substr(start, end - start);
}

let onLast = (ta) => ta.value.substr(0, ta.selectionStart).split("\n").length == ta.value.split("\n").length;
let scrollToBottom = (element) => {
  element.scroll({ top: element.scrollHeight, behavior: 'smooth' });
}

let code = document.getElementById("code");
code.setSelectionRange(code.value.length,code.value.length);

//override out
window.out = function(str, skipLineFeed=false) {
    let code = document.getElementById("code");

    //if the console already has been indentened for line input
    if (code.value.split('\n').slice(-1) == '   ') {
      //strip the leading 3 spaces
      str = str.replace(/^\s\s\s/,'')
    }

    code.value +=  str + (skipLineFeed ? "" : "\n");
    //joebo commented out since it didn't seem like it was doing anything
    //code.selectionStart = code.value.length;
    //code.selectionEnd = code.value.length;
    scrollToBottom(code);
    console.log(str);
    
}


window.out("A browser-based J REPL. Type )h for help.")
window.out("   ", true)

code.addEventListener("keydown", (e) => {
    if (e.key == "Enter") {
        e.preventDefault();
        let s = getLine(code);
        let str = s.trim();
 //       console.log('str| ' + str);
        let out = "";
        //jdo1("''") // execute empty string to clear last J engine call result
        //execute empty string to flush j engine
        if(str == ")h") {
          window.out("\nREPL Help:"+
"\n)cls - clears all text on screen."+
"\n)play - code examples to play with." +
"\n)ctrl+> to advance a lab"
); 
        window.out("   ", true)
}
        else if(str == ")cls") { code.value = "   "; }
        else if(str == ")play") { window.out(
                                "\nTo execute code examples, click on line and press return/enter.\n" + 
                                "\n 3 + 2.3 7 4500 1.2e4                                NB. Add 3 to vector of numbers"+
                                "\n i. 3 4                                              NB. create matrix of integers"+
                                "\n %. 3 3 $ 243 252 234                                NB. invert 3 by 3 matrix"+
                                "\n ;: 'I read what I want to read'                     NB. split string into boxed words"+
                                "\n (~.,.<@#/.~);: 'I read what I want to read'         NB. group by unique word and count appearances" +
                                "\n (2!:0) 'alert(\"hello world\")'                     NB. show alert popup" +
                                "\n smoutput 'hello: ', ((2!:0) 'prompt(\"name?\")')    NB. interact with host javascript" +
                                "\n (1!:0) 'jlibrary/system/main/*.ijs'                 NB. list directory matching *.ijs "
                                );
                                window.out("   ", true)
         }
        else if(str != "") { try {
          //no need to echo here since we override window.out  
          window.out("")
          jdo1(str);
          window.out("   ", true)

        } catch (obj) {
            window.out("ERROR: " + obj);
        } }
    }  
    if((event.ctrlKey && event.key == ".") || (event.ctrlKey && event.key == ">")) {
      jdo1("labnext ''")
    }
      
});


var _editorShown = true;
function toggleEditor(event) {
  if (event) {
    event.preventDefault();
    event.stopPropagation();
  }
  //hide the editor
  if (_editorShown) {
    document.getElementById('editContainer').style.display='none';
    document.getElementById('repl').style.height='85%';
  } else {
    document.getElementById('editContainer').style.display='';
    document.getElementById('repl').style.height='35%';
  }
  _editorShown = !_editorShown;
}

function runEditor() {        
    var editorValue = editor.getValue();    
    jsetstr('CODE',editorValue);
    var out = jdo1("(0!:101) CODE");
window.out("   ", true)
    document.getElementById("permalinkBase").href = '#code='+encodeURIComponent(editorValue);
    document.getElementById("permalink").style.display = '';

}
document.getElementById('toggleEditor').addEventListener('click', toggleEditor);        
document.getElementById('runEditor').addEventListener('click', runEditor);  

function checkPermalink() {
    var code = decodeURIComponent(window.location.hash).substr(1);
    if (code.substring(0,5)=='code=') {
      document.getElementById("permalinkBase").href = window.location.href;
      code = code.substring(5);
      editor.setValue(code);
      toggleEditor();
      document.getElementById("permalink").style.display = '';
    } 
    else if (code.toLowerCase().substring(0,4) == 'url=') {
        let url = code.substring(4);
        console.log(url);
        fetch(url).then(response=>response.text()).then(data=>{ 
            editor.setValue(data) 
            toggleEditor()
        });    
    }
    else {
      document.getElementById("permalink").style.display = 'none';
    }
  }
  
//use monaco on a bigger device
var useMonaco = window.innerWidth > 900;
if (useMonaco) {
  let x = document.createElement("script");
  x.src="https://unpkg.com/monaco-editor@latest/min/vs/loader.js"//your script path will goes gere
  document.querySelector("html").append(x);

} else {
  let codeEditor = document.createElement("textarea");
  codeEditor.style.height="100%";
  document.querySelector("#editor").append(codeEditor);
  window.editor = {
    setValue: function(value) {
      codeEditor.value = value;
    },
    getValue: function() {
      return codeEditor.value;
    }
  }
  toggleEditor();
  checkPermalink();
}

document.onreadystatechange = function(){
    if(document.readyState === 'complete' && useMonaco){
  
      require.config({ paths: { 'vs': 'https://unpkg.com/monaco-editor@latest/min/vs' }});
    
      // Before loading vs/editor/editor.main, define a global MonacoEnvironment that overwrites
      // the default worker url location (used when creating WebWorkers). The problem here is that
      // HTML5 does not allow cross-domain web workers, so we need to proxy the instantiation of
      // a web worker through a same-domain script
      window.MonacoEnvironment = {
        getWorkerUrl: function(workerId, label) {
          return `data:text/javascript;charset=utf-8,${encodeURIComponent(`
            self.MonacoEnvironment = {
              baseUrl: 'https://unpkg.com/monaco-editor@latest/min/'
            };
            importScripts('https://unpkg.com/monaco-editor@latest/min/vs/base/worker/workerMain.js');`
          )}`;
        }
      };
    
      require(["vs/editor/editor.main"], function () {
        window.editor = monaco.editor.create(document.querySelector('.editor'), {
          value: ``,
          language: 'j',
          theme: 'vs-dark',
        });

        //add keybinding to run all lines similar to jqt
        editor.addAction({
            id: 'my-run-editor',        
            // A label of the action that will be presented to the user in F1.
            label: 'Run Editor',
            // An optional array of keybindings for the action.
            keybindings: [
                monaco.KeyMod.CtrlCmd | monaco.KeyMod.Shift | monaco.KeyCode.KeyE,
                monaco.KeyMod.CtrlCmd |  monaco.KeyCode.KeyL,
            ],                
            contextMenuGroupId: 'navigation',        
            contextMenuOrder: 1.5,        
            // Method that will be executed when the action is triggered.
            // @param editor The editor instance is passed in as a convenience
            run: function (ed) {
                runEditor();
            }
        });
        
        //hide editor by default
        toggleEditor();

        checkPermalink()                  
    });
  }
}

var labs =[
'system/special_searches',
'general/towerofhanoi',
'general/seqmachine',
'general/huffman',
'livetexts/coleman',
'core/display',
'core/jtaste2',
'core/sparse',
'core/monad',
'core/intro',
'math/fntab',
'math/shapley',
'math/iter',
'math/bestfit',
'math/families',
'math/pythag3',
'math/averages',
'math/bincoefs',
'math/tables',
'math/volume',
'math/groups',
'math/frame',
'math/polynom',
'math/mathroot',
]
let labMenu = document.getElementById('labMenu')
document.getElementById("advanceLab").onclick = function() {
  jdo1("labnext''")
}
labs.forEach(x=>{
  //<a href="#toggle-editor" id="toggleEditor">Math/Averages</a>
  var labLink = document.createElement("a")
  labLink.setAttribute("href","#" + x);
  labLink.innerText = x;
  labMenu.appendChild(labLink);
  labMenu.onclick = function(e) {
    //load the labs utilities / doesn't hurt to reload each time
    jdo1("(0!:0) <'labs/labs805.ijs'")
    var labPath = e.target.getAttribute('href').slice(1); //drop the leading #
    var lab = labPath.slice(labPath.indexOf('/')+1);
    jdo1("lab 'labs/" + lab + ".ijt'")
    //go back to the base locale so the labs execute where the user can interact
    jdo1("('base';'z') copath 'jlab805'")

    document.getElementById("advanceLab").style.display='';
    e.preventDefault();
    return 0;
  }
})