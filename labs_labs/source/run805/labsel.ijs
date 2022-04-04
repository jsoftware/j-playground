NB. labsel.ijs      - main selection dialog

LABSEL=: 0 : 0
pc labsel closeok;pn "Lab Select";
menupop "Options";
menu comments "Labs display &Comment Text" "" "" "Show comments when running Labs";
menu sentences "Labs display J &Sentences" "" "" "Show sentences when running Labs";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu intro "&Introduction to Labs..." "" "" "";
menupopz;
groupbox "";
bin h;
cc s0 static;cn "Select a lab";
bin s;
cc browse button;cn "&Browse...";
bin z;
groupboxend;
groupbox "";
bin hvh;
cc s1 static;cn "Category:";
cc category combolist;
set category stretch 9;
bin z;
minwh 296 314;cc listbox listbox;
bin z;
bin v;
cc ok button;cn "&Run";
cc print button;cn "&Print";
bin s;
cc cancel button;cn "&Close";
bin z;
bin z;
groupboxend;
pas 6 4;pcenter;
rem form end;
)

LABSEL6=: 0 : 0
pc8j labsel closeok;pn "Lab Select";
menupop "Options";
menu comments "Labs display &Comment Text" "" "" "Show comments when running Labs";
menu sentences "Labs display J &Sentences" "" "" "Show sentences when running Labs";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu intro "&Introduction to Labs..." "" "" "";
menupopz;
xywh 22 24 248 22;cc s0 static;cn "Select a lab";
xywh 14 6 422 46;cc g0 groupbox rightmove;cn "";
xywh 326 22 100 24;cc browse button leftmove rightmove;cn "&Browse...";
xywh 22 78 74 22;cc s1 static;cn "Category:";
xywh 100 76 214 218;cc category combodrop ws_vscroll rightmove;
xywh 22 110 292 314;cc listbox listbox ws_border ws_vscroll rightmove bottommove;
xywh 326 112 100 24;cc ok button leftmove rightmove;cn "&Run";
xywh 326 142 100 24;cc print button leftmove rightmove;cn "&Print";
xywh 326 388 100 24;cc cancel button leftmove topmove rightmove bottommove;cn "&Close";
xywh 14 58 422 366;cc g1 groupbox rightmove bottommove;cn "";
pas 6 4;pcenter;
rem form end;
)

LABSELJA=: 0 : 0
pc labsel closeok;pn "Lab Select";
bin v;
cc s0 static;cn "Select a lab";
cc s1 static;cn "Category:";
wh _1 _2;cc category combolist;
wwh 1 _1 0;cc listbox listbox;
bin z;
pas 6 4;pcenter;
rem form end;
)

NB. =========================================================
labsel_run=: 3 : 0
if. wdisparent 'labsel' do.
  wd 'psel labsel;pshow;pactive' return.
end.
wd IFJA{::(IFJNET{::LABSEL;LABSEL6);LABSELJA
labshowcats''
if. IFJA do.
  labsel_listbox_select=: labsel_listbox_button
else.
  wd 'set comments checked ',":IFCOMMENTS
  wd 'set sentences checked ',":IFSENTENCES
  wd 'setfocus listbox'
  wdfit''
end.
wd 'pshow;'
)

NB. =========================================================
labsel_browse_button=: 3 : 0
p=. jpath '~user'
j=. '"Labs (*.ijt)|*.ijt|All Files (*.*)|*.*"'
if. IFJNET do.
  f=. mbopen '"Open File" "',p,'" "" ',j
else.
  f=. wd 'mb open1 "Open File" "',p,'" ',j
end.
if. #f do.
  labselrun f
end.
)

NB. =========================================================
labsel_listbox_button=: 3 : 0
if. #listbox do.
  labselrun 2 pick (".listbox_select) { LABCATSEL#LABS
end.
)

NB. =========================================================
labsel_print_button=: 3 : 0
if. #listbox do.
  if. IFJNET do.
    printfiles_j_ 2 pick (".listbox_select) { LABCATSEL#LABS
  else.
    wd 'mb print ', 2 pick (".listbox_select) { LABCATSEL#LABS
  end.
end.
)

NB. =========================================================
labsel_enter=: labsel_ok_button=: labsel_listbox_button
labsel_intro_button=: labselrun bind (jpath '~addons/labs/labs/labintro.txt')

NB. =========================================================
labselrun=: 3 : 0
labinit y
wd :: ] 'psel labsel;pclose;'
smact`smselact_jijs_@.IFJNET''
)

NB. =========================================================
labsel_cancel_button=: wd bind 'pclose'
labsel_exit_button=: labsel_cancel_button

NB. =========================================================
labsel_category_button=: 3 : 0
if. LABCAT -: <category do. return. end.
LABCAT=: <category
labshowcats''
)

NB. =========================================================
labsel_comments_button=: 3 : 0
IFCOMMENTS=: -. IFCOMMENTS
wd 'set comments checked ',":IFCOMMENTS
)

NB. =========================================================
labsel_sentences_button=: 3 : 0
IFSENTENCES=: -. IFSENTENCES
wd 'set sentences checked ',":IFSENTENCES
)

NB. =========================================================
labshowcats=: 3 : 0
if. LABCAT -: <ALL do.
  LABCATSEL=: 1 #~ #LABS
else.
  LABCATSEL=: ({."1 LABS) e. LABCAT
end.
labshowall''
)

NB. =========================================================
labsel_category_select=: labsel_category_button

NB. =========================================================
labshowall=: 3 : 0
if. -. (<'labsel') e. {."1 wdforms'' do. return. end.
wd 'set category items ', tolist LABCATS
wd 'setselect category ',":LABCATS i. LABCAT
d=. LABCATSEL # LABS
wd 'set listbox items ', tolist 1{"1 d
wd 'setselect listbox 0'
)
