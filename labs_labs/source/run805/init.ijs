NB. init
NB.
NB. LABDIR         lab directories        2 cols: shortname;fullname_j_
NB. LABCATS        current lab categories
NB. LABCATSEL      category selection mask
NB.
NB. LABS           matrix, columns:
NB.                0=category
NB.                1=titles
NB.                2=filenames
NB.                3=0 unused
NB.
NB. LABNDX         current lab index
NB. LABPATH        current lab path
NB. LABFILE        current lab file
NB.
NB. CODE           current code block
NB. CODENDX        current code index
NB. NDX            current section index
NB.
NB. CHAPTERDATA    contents of each chapter
NB. CHAPTERS       list of chapters
NB. CHAPTERNDX     indices of corresponding chapter
NB.
NB. SECTIONDATA    contents of each section
NB. SECTIONS       list of sections
NB. SECTIONINDEX   indices of corresponding sections

coclass 'jlab'

PATHSEP=: '/'
IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
