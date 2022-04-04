NB. servfnsw.ijs      - socket execution server
NB.
NB. This script sets up J as a socket execution server.
NB.
NB. For details see file: system/examples/socket/socket.txt

cocurrent 'z'

FONT=: FIXFONT
IFSHOW=: 1
IFWINDOW=: 1

signoff=: 2!:55

NB. =========================================================
NB. display form:
WPSERVER=: 0 : 0
pc server;pn "J Server";
xywh 4 4 112 11;cc e0 edit;
xywh 4 17 150 48;cc e1 editm;
xywh 120 3 34 11;cc cancel button;cn "Close";
pas 2 1;pcenter;
rem form end;
)

NB. =========================================================
NB. event handlers:
server_close=: signoff
server_break=: signoff
server_cancel_button=: signoff

NB. =========================================================
NB. write to controls:
write0=: 3 : 0
wd 'set e0 *',y
)

NB. =========================================================
write1=: 3 : 0
y=. 7{. 1 1}. _1 _1}. ": <y
y=. }.,LF,"1 y
wd 'set e1 *',y
)

NB. =========================================================
server_run=: 3 : 0
if. (<'server') e. <;._2 wd 'qp' do.
  wd 'psel server'
else.
  wd WPSERVER
  wd 'setfont e0 ',FONT
  wd 'setfont e1 ',FONT
end.
wd 'pshow'
)

NB. =========================================================
load '~addons/labs/labs/examples/socket/server.ijs'
