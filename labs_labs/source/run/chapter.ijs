NB. chapter

NB. =========================================================
LABCHAPTER=: 0 : 0
pc labchapter closeok;pn "Lab Chapter";
cc labid static;
cc labinfo static;cn " ";
bin hv;
minwh 240 200;cc listbox listbox;
bin zv;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin sz;
pas 4 2;pcenter;
rem form end;
)

LABCHAPTER6=: 0 : 0
pc labchapter closeok;pn "Lab Selection";
xywh 270 68 80 24;cc ok button leftmove rightmove;cn "OK";
xywh 270 98 80 24;cc cancel button leftmove rightmove;cn "Cancel";
xywh 12 70 240 200;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 14 16 332 22;cc labid static;
xywh 14 44 240 22;cc labinfo static;cn " ";
pas 4 2;pcenter;
rem form end;
)

NB. =========================================================
labfmt=: 4 : 0
DEL,(":x),'. ',y,DEL
)

NB. =========================================================
labchapter_run=: 3 : 0
wd IFJNET{::LABCHAPTER;LABCHAPTER6
s=. #y
wd 'set labid text *',(gettitle''),' (',(":s),(s plurals ' chapter'),')'
wd 'set labinfo text *Select a chapter:'
d=. (1+i.#y) labfmt each y
wd 'set listbox items ',;d
wd 'setfocus listbox'
wd 'pshow;'
)

NB. =========================================================
labchapter=: 3 : 0
val=. dltb }.y
msk=. (<'chapter')={."1 LABDEF
if. -. 1 e. msk do.
  echo 'There are no chapters in the lab' return.
end.
if. 0=#val do.
  chp=. {:"1 msk#LABDEF
  if. IFQT do.
    labchapter_run chp
  else.
    def=. chp ,each <'''',LF
    echo }: ;'lab'':'&, each def
  end.
  return.
end.
ndx=. LABDEF i. 'chapter';val
if. 0=#ndx do.
  echo 'chapter not found: ',val
else.
  LABPOS=: ndx
  lab 0
end.
EMPTY
)

NB. =========================================================
labchapter_listbox_button=: 3 : 0
ndx=. 1 + ".listbox_select
LABPOS=: ndx i.~ +/\ (<'chapter')={."1 LABDEF
wd 'pclose'
echo ''
lab 0
)

NB. =========================================================
labchapter_enter=: labchapter_ok_button=: labchapter_listbox_button
labchapter_close=: labchapter_cancel=: labchapter_cancel_button=: wd bind 'pclose'
