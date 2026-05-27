NB. startup J code for the j playground
NB. make changes in the playground source directory and rebuild

Displayload_j_=: 0

jpathsep_z_=: '/'&(('\' I.@:= ])})

SystemFolders_j_=: (i.&' ' ({.;}.@}.)]) ;._2 (0 : 0)
addons /addons
bin /jlibrary/bin
home /home/web_user
system /jlibrary/system
)

SystemFolders_j_=: SystemFolders_j_,(;:'install temp user'),.<''
