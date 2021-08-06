
testpath=: 'test/'

os=. (('Linux';'Darwin') i. <UNAME) pick ;:'linux mac win'
testres=: 'test',os,'.txt'

0!:0 <testpath,'tsu.ijs'

RES=: RUN ddall -. < testpath

3 : 0''
msg=. 9!:14''
if. 0=#RES do.
  msg=. msg,LF,'all tests correct'
else.
  msg=. msg,LF,'test fails:'
  msg=. msg,;<@(LF,dtb) "1 RES
end.
msg fwrites testres
)

exit ''
