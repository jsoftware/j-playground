NB. labjmp

NB. =========================================================
LABJUMP=: 0 : 0
pc labjump closeok;pn "Lab Selection";
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

LABJUMP6=: 0 : 0
pc labjump closeok;pn "Lab Selection";
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
labjump_run=: 3 : 0
if. 1=#CHAPTERDATA do.
  info 'There is only one chapter in the lab'
  return.
end.
wd IFJNET{::LABJUMP;LABJUMP6
s=. #CHAPTERS
wd 'set labid text *',LABTITLE,' (',(":s),(s plurals ' chapter'),')'
wd 'set labinfo text *Select a chapter:'
d=. (1+i.#CHAPTERS) labfmt each CHAPTERS
wd 'set listbox items ',;d
wd 'setselect listbox ',":CHAPTERNDX
wd 'setfocus listbox'
wd 'pshow;'
)

NB. =========================================================
NB. switch to given chapter
labchapter=: 3 : 0
labopenchapter <: 1 >. y <. #CHAPTERS
labchapterline''
lab 0
)

NB. =========================================================
labjump_listbox_button=: 3 : 0
labopenchapter ".listbox_select
labchapterline''
wd 'pclose'
labrun''
)

NB. =========================================================
labjump_enter=: labjump_ok_button=: labjump_listbox_button
labjump_close=: labjump_cancel=: labjump_cancel_button=: wd bind 'pclose'
