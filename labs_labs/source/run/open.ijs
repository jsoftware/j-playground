NB. open

NB. =========================================================
labopen=: 3 : 0
labdefs''
if. -. fexist y do. echo 'not found: ',y return. end.
LABVER=: getversion y
if. LABVER=0 do. lab805 y return. end.
rc=. labparse y
if. -. rc -: 0 do.
  echo rc
  labdefs'' return.
end.
LABFILE=: y
LABPOS=: 0
if. IFJHS do.
  ADVANCE_jijx_=: 'lab'
  a=. 'ctrl+. or menu > advances'
  if. 3 = nc <'labopened_jhs_' do.
    labopened_jhs_ y
  end.
elseif. IFQT do.
  a=. 'ctrl+j advances'
elseif. 1 do.
  a=. 'lab 0  NB. advances (create a shortcut key!)'
end.
echo a
labstatus''
lab 0
EMPTY
)
