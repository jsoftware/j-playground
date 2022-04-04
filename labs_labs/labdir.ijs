NB. labdir.ijs
NB.
NB. defines noun LABDIR as a table of shortname + full pathname
NB. for lab directories.
NB.
NB. If you want to modify this, first make a copy in your
NB. configuration directory (specified by CONFIG_j_ in
NB. profile.ijs), then modify the copy. This will be read
NB. instead of the original script.
NB.
NB. Use an underscore for a blank in the shortname.

j=. <;._2 (0 : 0)
Core_Language      ~addons/labs/labs/core
Debug              ~addons/labs/labs/debug
Graphics           ~addons/labs/labs/graphics
System             ~addons/labs/labs/system
General_Interest   ~addons/labs/labs/general
Math               ~addons/labs/labs/math
Live_Texts         ~addons/labs/labs/livetexts
User               ~user/labs
Addons             ~addons
)

ndx=. j i.&> ' '
nms=. ndx {.each j
dir=. ndx }.each j
ndx=. (=&' ' i. 0:) &> dir
dir=. ndx }.each dir
LABDIR=: nms ,. jpath each dir
