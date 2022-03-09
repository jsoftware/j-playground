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
"\n)play - code examples to play with."); 
        window.out("   ", true)
}
        else if(str == ")cls") { code.value = "   "; }
        else if(str == ")play") { window.out(
                                "To execute code examples, click on line and press return/enter.\n" + 
                                "\n 3 + 2.3 7 4500 1.2e4                        NB. Add 3 to vector of numbers"+
                                "\n i. 3 4                                      NB. create matrix of integers"+
                                "\n %. 3 3 $ 243 252 234                        NB. invert 3 by 3 matrix"+
                                "\n %: +/ *: i. 3 4                             NB. geometric average of matrix columns" +
                                "\n %: @: (+/) @: #: @: i. 3 4 "+
                                "\n ;: 'I read what I want to read'             NB. split string into boxed words"+
                                "\n (~.,.<@#/.~);: 'I read what I want to read' NB. group by unique word and count appearances" +
                                "\n(1!:0) 'jlibrary/system/main/*.ijs           NB. list directory matching *.ijs " +
                                "\n(0!:1) <'jlibrary/system/main/stdlib.ijs'    NB. load stdlib");
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
});