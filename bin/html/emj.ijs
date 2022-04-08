NB. startup J code for the j playground

Displayload_j_  =: 0
SystemFolders_j_ =: |: ('temp';'/') ,. ('addons';'/addons/')
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
