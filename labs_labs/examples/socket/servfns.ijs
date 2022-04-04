NB. servfns.ijs      - socket execution server
NB.
NB. see file: system/examples/socket/socket.txt for details
NB.
NB. The server accepts commands in the following format:
NB.
NB.  'close'            - closes socket
NB.  'exit'             - terminates server
NB.   other text        - executes text as a J sentence, returns result in
NB.                       clipboard format, or 'unable to execute' if error
NB.  'do';text          - executes text as a J sentence, returns encoded result
NB.  'get';'name'       - retrieves encoded value of name
NB.  'set';'name';codes - sets name to encoded value

load 'socket'
load '~system/extras/migrate/socket.ijs'

cocurrent 'base'
cocurrent 'z'

SKJDAT=: a.{~128+a.i.'jdat'
SKMAX=: 25000
SKPORT=: 800

signoff=: 2!:55
sockerror=: 13!:8 & 3

socksend=: 4 : 'sdcheck x sdsend y,0'
socksendcode=: 4 : '(tocode x) socksend y'

3 : 0''
if. _1=nameclass <'IFWINDOW' do. IFWINDOW=: 0 end.
if. _1=nameclass <'IFSHOW' do. IFSHOW=: 1 end.
0
)

NB. =========================================================
NB. clipfmt
clipfmt=: 3 : 0
if. 0 e. $y do. CRLF return. end.
t=. 3!:0 y
if. 2=t do.
  y=. ,y,"1 CRLF
elseif. 32<:t do.
  y=. ,&TAB @ ": &.>y
  y=. ;,&CRLF@}: &.><@;"1 y
elseif. 1 do.
  y=. ;,&CRLF @ ": &.><"1 y
  y=. '-' (I. y='_') } y
  y=. TAB (I. y=' ') } y
end.
y
)

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
NB. socket_do:
socket_do=: 3 : 0
'read write error'=. sdcheck sdselect''

if. #error do.
  sockerror 'error in socket: ',":error
end.

if. 0=#read do. empty'' return. end.

REQ=: ,~a:

while. #read do.
  sk=. {.read
  read=. }.read

  if. sk e. SKACCEPT do.
    txt=. >{.sdcheck sdrecv sk,SKMAX,0
    txt=. fromcode txt

NB. text argument ----------------------------

    if. 2 = 3!:0 txt do.

      if. txt -: 'close' do.
        'command close' socksend sk
        sdclose sk
        REQ=: 'close';''

      elseif. txt -: 'exit' do.
        'command exit' socksend sk
        sdclose sk
        signoff''

      elseif. txt -: 'hide' do.
        'command hide' socksend sk
        IFSHOW=: 0
        REQ=: 'hide';''

      elseif. txt -: 'show' do.
        'command show' socksend sk
        IFSHOW=: 1
        REQ=: 'show';''

      elseif. 1 do.
        res=. 1 sockit txt
        (clipfmt res) socksend sk
        REQ=: txt;res

      end.

NB. boxed argument ----------------------------

    else.
      txt=. 3{.txt
      cmd=. 0 pick txt
      val=. ,":1 pick txt

      if. cmd -: 'cmd' do.

        if. val -: 'close' do.
          'command close' socksend sk
          sdclose sk
          REQ=: 'close';''

        elseif. val -: 'exit' do.
          'command exit' socksend sk
          sdclose sk
          signoff''

        elseif. val -: 'hide' do.
          'command hide' socksend sk
          IFSHOW=: 0
          REQ=: 'hide';''

        elseif. val -: 'show' do.
          'command show' socksend sk
          IFSHOW=: 1
          REQ=: 'show';''

        elseif. 1 do.
          res=. 1 sockit val
          res socksendcode sk
          REQ=: ('cmd: ',val);res

        end.

      elseif. cmd -: 'do' do.
        res=. 0 sockit val
        res socksendcode sk
        REQ=: ('do: ',val);res

      elseif. cmd -: 'get' do.
        if. '_' ~: _1{.val do. val=. val,'__' end.
        try. 1,res=. ".val
        catch. 'unable to get: ',val end.
        res socksendcode sk
        REQ=: ('get: ',val);res

      elseif. cmd -: 'set' do.
        dat=. 2 pick txt
        if. '_' ~: _1{.val do. val=. val,'__' end.
        try. res=. empty ".val,'=:dat'
        catch. res=. 'unable to set: ',val end.
        res socksendcode sk
        REQ=: ('set: ',val);res

      end.

    end.

  elseif. sk=SKLISTEN do.
    new=. > sdcheck sdaccept sk
    SKACCEPT=: SKACCEPT,new
    REQ=: ('open socket: ',":new);''

  elseif. 1 do.
    sockerror 'unknown socket: ',":sk
  end.

end.

if. IFWINDOW do.
  if. IFSHOW do.
    write0 0 pick REQ
    write1 1 pick REQ
    wd 'pshow'
  else.
    wd 'pshow hide'
  end.
  empty''
else.
  if. IFSHOW do. REQ else. empty'' end.
end.

)

NB. =========================================================
NB. sockit
NB. execute verb for socket server
NB. form: opt sockit tome
NB. opt=0 ignore execution result, 1=keep execution result
sockit=: 4 : 0
try. 1;res=. (3 : y) ''
  if. 0=x do. res=. i.0 0 end.
catch. res=. 'unable to execute' end.
res
)

NB. =========================================================
NB. socklisten    - server: open socket and listen
NB. y is number of queued connections (''=1)
socklisten=: 3 : 0
sdcleanup''
SKACCEPT=: ''
SKLISTEN=: 0 pick sdcheck sdsocket''
name=. sdcheck sdgethostbyname'localhost'
sdcheck sdbind SKLISTEN;name,<SKPORT
sdcheck sdlisten SKLISTEN, {.y,1
SKLISTEN
)

NB. =========================================================
sockserver=: 3 : 0
socket_handler=: socket_do
socklisten''
if. IFWINDOW do. server_run'' end.
)

NB. =========================================================
cocurrent 'base'
sockserver''
