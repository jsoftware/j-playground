NB. startup J code for the j playground

Displayload_j_  =: 0
SystemFolders_j_ =: |: ('temp';'') ,. ('addons';'/addons/')
load 'jlibrary/system/util/scripts.ijs'
IFTESTPLOTJHS_z_=: 1
require 'plot'

plotJS_j_ =: {{)n
    var html = jgetstr("imghtml_j_");
    tcmreturn(html);    
}}


cocurrent 'jws'

canvasnum=: 0
Ignore_j_=: ~.'jhs';Ignore_j_
IFJHS_jzplot_=: 1
IFJHS_jviewmat_=: 1

cocurrent 'base'

NB. =========================================================
plotcanvas=: 3 : 0
    d=. fread '~temp/plot.html'
    canvasnum_jws_=: >:canvasnum_jws_
    canvasname=. 'canvas',":canvasnum_jws_
    c=. canvasname,' ',":CANVAS_DEFSIZE_jzplot_
    d=. (('function graph()'E.d)i.1)}.d
    d=. (('</script>'E.d)i.1){.d
    d=. d,'graph();'
    d=. d rplc'canvas1';canvasname
    imghtml_j_ =: '7',c,LF,d
    (2!:0) plotJS_j_
)

NB. =========================================================
plotdef=: 3 : 0
'CANVAS_DEFSHOW_jzplot_ CANVAS_DEFWINDOW_jzplot_ CANVAS_DEFSIZE_jzplot_ JHSOUTPUT_jzplot_'=: y
JHSOUTPUT_jzplot_=: 'canvas'
i.0 0
)


BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)


require 'graphics/viewmat'

viewmat_jviewmat_=: 3 : 0
'' viewmat y
:
a=. '' conew 'jviewmat'
xx__a=: x [ yy__a=: y
if. VIEWMATGUI do.
  empty vmrun__a ''
else.
  empty vmrun__a ''
  (setalpha no_gui_bitmap__a'') writepng jpath '~temp/',TITLE__a,'.png'
  TITLE=. TITLE__a
  destroy__a ''

  d=. tobase64_base_ fread (<'/viewmat.png')
  imghtml_j_ =: '8',d
  (2!:0) plotJS_j_
end.
)
