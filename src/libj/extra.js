//just some dummy javascript to try out
var jdo = Module.cwrap('em_jdo','string',['string'])

var newDiv = document.createElement('div')
newDiv.id = 'inputDiv'
newDiv.innerHTML = '<div><span style="font-size:2em">Input</span> <textarea style="width:500px;height:40px" id="input"></textarea><input type="button" id="submit" value="Run"></div>'
//etc.
document.body.appendChild(newDiv)
document.getElementById('submit').onclick = function() {
  var result = jdo(document.getElementById('input').value);
  outputDiv.innerHTML = result;
}

var outputDiv = document.createElement('div')
document.body.appendChild(outputDiv)