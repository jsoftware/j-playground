// websocket

// ws readyState:
// CONNECTING 0 The connection is not yet open.
// OPEN       1 The connection is open and ready to communicate.
// CLOSING    2 The connection is in the process of closing.
// CLOSED     3 The connection is closed or couldn't be opened.

"use strict";

var ws = {};
var jws = {};
var jver;

var jdo1 = Module.cwrap('em_jdo','string',['string'])

var ws = {
  open: function() {},
  close: function() {},
  send: function(cmd) { 
    //console.log(cmd);
    var ret = jdo1(cmd);
    //tcmreturn slices the first character off
    tcmreturn(' ' + ret + '\n');
  }
}
function wsopen() {}
/*
// ---------------------------------------------------------------------
function wsopen() {

 ws = new WebSocket(wsprotocol() + Config.host + ":" + Config.port);
 O("new ws",ws);
 ws.state = 0;

 ws.onopen = function() {
   O("ws.onopen");
  ws.state = 1;
  showstate(true);
  tcm.focus();
 }

 ws.onclose = function() {
   O("ws.onclose");
  showstate(false);
  if (ws.state === 3)
   msgbox("The connection has closed");
  ws = {};
 }

 ws.onerror = function(e) {
   O("ws.onerror");
  if (ws.state === 0)
   msgbox("Could not open connection to server");
 }

 ws.onmessage = function(e) {
  O("on message e,state",e, ws.state);
  if (ws.state === 3)
   return tcmreturn(e.data);
  ws.state++;
  if (ws.state === 2)
   ws.send("9!:14''");
  else
   jver = e.data;
 }
}
*/

// ---------------------------------------------------------------------
function disconnect() {
 ws.state = 4;
 ws.close();
}

// ---------------------------------------------------------------------
// originally this connected to a docker instance
// now just does the load ...
function connect() {
  initload();
}

// ---------------------------------------------------------------------
function wsprotocol() {
 return "ws://";
}

// ---------------------------------------------------------------------
function reconnect() {
 ecmsnap();
 connect();
}
