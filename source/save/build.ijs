NB. jplay build

dat=. readsource_jp_ '~Playground/base'
dat=. dat,readsource_jp_ '~Playground/help'
dat fwritenew '~.Playground/bin/html/emj.ijs'
dat fwritenew '~.Playground/bin/html2/emj.ijs'

textview dat