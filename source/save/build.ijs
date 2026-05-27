NB. jplay build

dat=. readsource_jp_ '~Playground/base'
dat=. dat,readsource_jp_ '~Playground/help'
dat=. dat,LF,'cocurrent ''base''',LF
dat fwritenew '~.Playground/extra/emj.ijs'
