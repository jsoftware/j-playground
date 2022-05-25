NB. startup J code for the j playground
NB. make changes in the playground source directory and rebuild

Displayload_j_=: 0
SystemFolders_j_=: |: ('temp';'') ,. ('addons';'/addons/')

load 'jlibrary/system/util/scripts.ijs'
load 'jlibrary/system/util/pacman.ijs'

IFTESTPLOTJHS_z_=: 1

IFJHS_jzplot_=: 1
IFPLAY_jviewmat_=: 1

getJS_j_=: {{)n
var html = jgetstr("playhtml_j_");
tcmreturn(html);
}}

canvasnum_jws_=: 0
Ignore_j_=: ~.'jhs';Ignore_j_

boxdraw_j_ 0
