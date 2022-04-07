NB. startup J code for the j playground

Displayload_j_  =: 0
SystemFolders_j_ =: |: ('temp';'/') ,. ('addons';'/addons/')
load 'jlibrary/system/util/scripts.ijs'
IFTESTPLOTJHS_z_=: 1
require 'plot'

plotJS_j_ =: {{)n
    setTimeout(function() {
        var html = jgetstr("imghtml_j_");
        //alert(html)
        if (!_plotShown) {
            togglePlot();
        }
        var iframe = document.getElementById('plotFrame');
        iframe.sandbox = 'allow-same-origin';
        iframe.contentWindow.document.open();
        iframe.contentWindow.document.write(html);
        iframe.contentWindow.document.close();
        
    },500);
}}

viewimage_j_ =: 3 : 0
    imghtml_j_ =: (1!:1) <y
    (2!:0) plotJS
    1
)
