NB. socklab.ijs        Some sample socket verbs.
NB.
NB. Used in the Sockets and the Internet Lab.

require 'convert strings'

cocurrent 'z'

NB. =========================================================
NB.     conn host;port
NB. Return a non-blocking socket connected
NB. to the host and port specified.
conn=: verb define   NB. connect to a particular server
'host port'=. y
if. 0~:s=. >{.x=. sdgethostbyname host do. s return. end.
s=. >{.sdcheck sdsocket''
sdconnect s;(}.x),<port
0,s[sdioctl s,FIONBIO_jsocket_,1
)

NB. =========================================================
NB.     data send sockno
NB. Send  data,CRLF  through sockno.
NB. Return sockno.
send=: ] [ [: sdcheck ,&(CR,LF)@[ sdsend ] , 0:

NB. =========================================================
NB.     read sockno
NB. Read all available bytes on sockno.
recv=: [: >@{:@sdcheck@sdrecv ] , sdnread , 0:

NB. =========================================================
NB.   sockno req request
NB. Send request (and CRLF) to sockno, and
NB. wait up to a minute for a reply.
NB. Only waits for first read.
req=: dyad define
y send x
sdselect x;'';'';60000  NB. wait a minute
recv x
)

NB. =========================================================
NB.     [timeout] recvall sockno
NB. Read all bytes from sockno (until other
NB. side closes socket), or until timeout
NB. has expired.  Timeout is in milliseconds
NB. and defaults to 60000.
recvall=: verb define   NB. read all until sock close.
60000 recvall y
:
z=. ''
while. 1 do.
  if. -.y e. >{.sdcheck sdselect y;'';'';x do. 0 return. end.
  if.0=#n=. >{. sdcheck sdrecv y,10240,0 do. break. end.
  z=. z,n
end.
)

NB. =========================================================
NB.    sdnread sockno
NB. Return number of bytes available for
NB. reading off sockno.
sdnread=: [: {:@sdioctl ,&(FIONREAD_jsocket_,0)

NB.    request webreq host[;port]
NB. Send request (,CRLF) to specified host
NB. and port (default 80).  Wait for and
NB. return all resulting data.
webreq=: dyad define
y=. (;&80)^:(0:=L.) y
if. 0~:{.sk=. conn y do. {.sk return. end.
x send sk=. {:sk
(sdclose]recvall) sk
)

NB. =========================================================
NB.      [display] webget url
NB. Return document specified by url.  Url
NB. is:   host[:port]/path
NB. if display is 1, display a progress bar
NB. showing how much of the file has been
NB. received.  Default display is 1.
webget=: verb define
1 webget y
:
'host path'=. (({.;}.)~ i.&'/') y
if. x=0 do. wd=. ] end.  NB. skip windowing stuff
host=. 2{.<;._1 ':',host,':80'
if. 0=#$x=. ('HEAD ',path,' HTTP/1.0',CR,LF,CR,LF) webreq host=. ({.host),".&.>{:host do. x return. end.
if. -.'HTTP/1.1 2'-:10{.>{.x=. <;._2 x-.CR do. >{.x return. end.
len=. ".>{:;:>{.(((<'content-length:')-:&> 15{.&.>tolower&.>x)#x),<'Content-length: _1'
if. 0~:{.sk=. conn host do. {.sk return. end.
('GET ',path,CR,LF) send sk=. {:sk
wd 'pc webget;pn "',y,'";xywh 0 0 155 12;cc pb progress'
wd 'xywh 0 12 155 12;cc out static;setfont out "MS Sans Serif" 12;pcenter;pas 0 0;pshow'
if. len=_1 do. wd 'set out *Receiving unknown number of bytes.' end.
z=. ''
while. 1 do.
  sdcheck sdselect sk;'';'';60000
  if.0=#n=. >{. sdcheck sdrecv sk,10240,0 do. break. end.
  z=. z,n
  if. len~:_1 do.
    wd 'set pb ',p=. ":<.100*(#z)%len
    wd 'set out *Received: ',(":#z),'/',(":len),' (',p,'%)'
  end.
end.
wd 'pclose'
z[sdclose sk
)

NB. =========================================================
NB.        sdme [sockno|'']
NB. Return my host name.  Uses reverse lookup
NB. on IP address associated with sockno, or
NB. the result of sdgethostname if either
NB. gethostbyaddr doesn't work, or if no sockno
NB. is given.
sdme=: 3 : 0
ip=. 10022;'' [ hn=. >{.sdcheck sdgethostname''
if. -.y-:'' do.
  ip=. sdgethostbyaddr 2{.sdcheck sdgetsockname y end.
>(0=>{.ip){hn;{:ip
)

NB. =========================================================
NB.      fortune ''
NB. Read random saying from the www.jsoftware.com site
NB. (provided by Unix's "fortune" command), and display
NB. it.
fortune=: verb define
x=. toJ 0 webget 'www.jsoftware.com/cgi-bin/fortune.cgi'
NB. return text between <pre> tags.
z=. 'Result of http://www.jsoftware.com/cgi-bin/fortune.cgi',LF
z=. z,5}.}:'</pre>' taketo '<pre>' dropto x
)