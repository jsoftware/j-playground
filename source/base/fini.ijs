NB. fini

cocurrent 'z'

NB. =========================================================
NB. run startup.ijs
startupJS=: 0 : 0
// only execute the startup.ijs if the querystring doesn't have nostartup... this allows a person to fix a broken startup
// we don't need to check for the presence of startup.ijs because it will execute an empty string if it doesn't exist
if (window.location.href.indexOf('nostartup')==-1) {
  //needs to run in a setTimeout because J can't recursively call Javascript which calls J for some reason
  setTimeout(function() { jdo1("(0!:0) File_plj_ 'startup.ijs'") },10);
}
)

(2!:1) startupJS
