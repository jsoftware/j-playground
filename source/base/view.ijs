
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
playhtml_j_=: '7',c,LF,d
(2!:0) getJS_j_
)

NB. =========================================================
plotdef=: 3 : 0
'CANVAS_DEFSHOW_jzplot_ CANVAS_DEFWINDOW_jzplot_ CANVAS_DEFSIZE_jzplot_ JHSOUTPUT_jzplot_'=: y
JHSOUTPUT_jzplot_=: 'canvas'
i.0 0
)

NB. =========================================================
BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)
