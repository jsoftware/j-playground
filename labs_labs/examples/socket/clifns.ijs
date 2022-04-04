NB. clifns.ijs    - example of socket client
NB.
NB. for details see file: system/examples/socket/socket.txt
NB.
NB.   sockopen        - open connection
NB.
NB.   sockcmd         - send J sentence, return result
NB.   sockdo          - send J sentence to be executed
NB.   sockget         - get value of J name
NB.   sockset         - set value to J name
NB.   socktext        - send sentence, return text result
NB.
NB.   sockerror       - signal socket error
NB.
NB.   SK              - socket
NB.   SKPORT          - port number
NB.   SKMAX           - maximum transmission size
NB.   SKJDAT          - indicate J data
NB.
NB.   fromcode        - decode transmitted data
NB.   tocode          - encode data for transmission

load 'socket'
load '~system/extras/migrate/socket.ijs'
cocurrent 'base'
cocurrent 'z'

SKJDAT=: a.{~128+a.i.'jdat'
SKMAX=: 25000
SKPORT=: 800

sockerror=: 13!:8 & 3

NB. =========================================================
fromcode=: 3 : 0
dat=. y
if. SKJDAT -: 4{.dat do.
  3!:2 [ 4}.dat
end.
)

NB. =========================================================
tocode=: 3 : 0
SKJDAT,3!:1 y
)

NB. =========================================================
NB. sockcmd
NB. send command, get result
sockcmd=: 3 : 0
dat=. tocode 'cmd';y
sdcheck dat sdsend SK,0
fromcode >{.sdcheck sdrecv SK,SKMAX,0
)

NB. =========================================================
NB. sockdo
NB. send string to be executed
sockdo=: 3 : 0
dat=. tocode 'do';y
sdcheck dat sdsend SK,0
fromcode >{.sdcheck sdrecv SK,SKMAX,0
)

NB. =========================================================
NB. sockget
NB. send name to be retrieved
sockget=: 3 : 0
dat=. tocode 'get';y
sdcheck dat sdsend SK,0
fromcode >{.sdcheck sdrecv SK,SKMAX,0
)

NB. =========================================================
NB. sockset      name sockset value
NB. send name to be assigned
sockset=: 4 : 0
dat=. tocode ('set';x),<y
sdcheck dat sdsend SK,0
fromcode >{.sdcheck sdrecv SK,SKMAX,0
)

NB. =========================================================
NB. socktext
NB. send command, get text result in clipboard format
socktext=: 3 : 0
sdcheck y sdsend SK,0
>{.sdcheck sdrecv SK,SKMAX,0
)

NB. =========================================================
NB. sockopen   - client: open socket and connect
sockopen=: 3 : 0
sdcleanup''
host=: sdcheck sdgethostbyname 'localhost'
SK=: 0 pick sdcheck sdsocket''
sdcheck sdconnect SK;host,<SKPORT
SK
)

NB. =========================================================
cocurrent 'base'
sockopen''
