NB. parse

NB. =========================================================
NB. parse file, returns 0 or error message
NB. if OK, defines:
NB.  LABDEF as 2-col table of tag;value
NB.  LABNOS corresponding line numbers
labparse=: 3 : 0
dat=. 'b' fread y
if. dat -: _1 do. 'not found: ',y return. end.

dat=. dtb each remcomments dat

res=. i. 0 2
nos=. i. 0
pos=. 0

while. #dat do.
  txt=. dlb 0 pick dat
  if. isnote txt do.
    'dat len'=. remnote dat
    pos=. pos + len continue.
  end.
  if. isnbkey txt do.
    'key dat len'=. getkey dat
    res=. res,'key';key
    nos=. nos, pos
    pos=. pos + len continue.
  end.
NB.   if. #txt do. nos=. nos, pos end.
  nos=. nos, pos
  dat=. }.dat
  pos=. pos + 1
  if. 0=#txt do.
    res=. res,'txt';'' continue.
  end.
  if. t=. iscolon txt do.
    ndx=. 1 + dat i. <,')'
    if. t=1 do.
      res=. res,'cmd';toLF (<txt),ndx{.dat
    else.
      res=. res,'txt';toLF }: ndx {.dat
    end.
    dat=. ndx }. dat
    pos=. pos + ndx continue.
  end.
  if. isnblab txt do.
    ndx=. txt i. ':'
    res=. res,(6}.ndx{.txt);(ndx+1)}.txt continue.
  end.
  if. isnb txt do.
    ndx=. 0 i.~ *./\ (isnb &> dat) > isnblab &> dat
    res=. res,'txt';toLF delnb each (<txt), ndx {. dat
    dat=. ndx }. dat
    pos=. pos + ndx continue.
  end.
  res=. res,'cmd';txt
end.

LABDEF=: res
LABNOS=: nos
LABNDX=: ({.-]) +/\. (<'key') ~: {."1 LABDEF
0
)
