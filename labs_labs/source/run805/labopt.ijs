NB. labopt

LABOPT=: 0 : 0
pc labopt;pn "Lab Options";
bin vh;
groupbox "Lab Displays";
cc comments checkbox;cn "Comment text";
cc sentences checkbox group;cn "J sentences";
groupboxend;
bin v;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin szzsz;
pas 6 6;pcenter;
rem form end;
)

LABOPT6=: 0 : 0
pc labopt;pn "Lab Options";
xywh 18 18 226 78;cc g0 groupbox;cn "Lab Displays";
xywh 36 42 152 22;cc comments checkbox;cn "Comment text";
xywh 36 66 152 22;cc sentences checkbox group;cn "J sentences";
xywh 272 18 80 24;cc ok button;cn "OK";
xywh 272 48 80 24;cc cancel button;cn "Cancel";
pas 6 6;pcenter;
rem form end;
)

NB. =========================================================
labopt_run=: 3 : 0
wd IFJNET{::LABOPT;LABOPT6
wd 'set comments value ',":IFCOMMENTS
wd 'set sentences value ',":IFSENTENCES
wd 'pshow;'
)

NB. =========================================================
labopt_close=: 3 : 0
IFCOMMENTS=: 0 ". comments
IFSENTENCES=: 0 ". sentences
if. LABOUTPUT *. IFCOMMENTS do.
  output=: [: empty 1!:2 & 2
else.
  output=: ]
end.
wd 'pclose'
)

NB. =========================================================
labopt_cancel=: labopt_cancel_button=: wd bind 'pclose'
labopt_ok_button=: labopt_enter=: labopt_close
