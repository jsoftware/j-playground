require 'arc/zlib'

coclass 'jpng'
IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
3 : 0''
if. (IFJNET +. IFIOS +. UNAME-:'Android') do. USEQTPNG=: USEPPPNG=: 0 end.
if. 0~: 4!:0<'USEQTPNG' do.
  USEQTPNG=: IFQT
end.
if. 0~: 4!:0<'USEJAPNG' do.
  USEJAPNG=: IFJA
end.
if. 0~: 4!:0<'USEJNPNG' do.
  USEJNPNG=: IFJNET
end.
if. (0~: 4!:0<'USEPPPNG') > IFIOS +. UNAME-:'Android' do.
  USEPPPNG=: (0 < #1!:0 jpath '~addons/graphics/pplatimg/pplatimg.ijs')
  require^:USEPPPNG 'graphics/pplatimg'
  if. USEPPPNG *. UNAME-:'Linux' do.
    USEPPPNG=: (LIBGDKPIX_pplatimg_,' dummyfunction + n')&cd :: (2={.@cder) ''
    USEPPPNG=: 0
  end.
end.
require^:USEPPPNG 'graphics/pplatimg'
EMPTY
)

magic=: 137 80 78 71 13 10 26 10{a.
ffilter0=: 4 : 0
({.a.),"1 y return.
)
ffilter=: 4 : 0
y=. a.i. y
sy=. $y
r=. 0$0
prev=. ({:sy)#0
for_i. i.{.sy do.
  type=. 0
  iy=. i{y
  sum=. +/@signbyte iy
  sum=. sum, +/@signbyte sub=. 256&| iy - (-x)}.(x#0),iy
  sum=. sum, +/@signbyte up=. 256&| iy - prev
  sum=. sum, +/@signbyte ave=. 256&| iy - <.@-: prev+(-x)}.(x#0),iy
  sum=. | sum, +/@signbyte pae=. 256&| iy - paeth"1 ((-x)}.(x#0),iy),.prev,.((-x)}.(x#0),prev)
  type=. sum i.(<./sum)
  prev=. iy
  if. 1=type do.
    r=. r, type, sub
  elseif. 2=type do.
    r=. r, type, up
  elseif. 3=type do.
    r=. r, type, ave
  elseif. 4=type do.
    r=. r, type, pae
  elseif. do.
    r=. r, type, iy
  end.
end.
(0 1+sy)$a.{~r
)
rfilter=: 4 : 0
f=. a.i. {."1 y
y=. a.i. }."1 y
sy=. $y
r=. 0$0
prev=. ({:sy)#0
for_i. i.{.sy do.
  iy=. i{y
  if. 1=i{f do.
    r=. r, prev=. , <. |: 256&| +/\"1 |: (-x)[\ iy
  elseif. 2=i{f do.
    r=. r, prev=. iy (256&|@:+) prev
  elseif. 3=i{f do.
    r=. r, prev=. prev (x rave) iy
  elseif. 4=i{f do.
    raw=. x#0
    prevbpp=. (-x)}.(x#0),prev
    for_j. i.#iy do.
      raw=. raw, 256&| (j{iy) + paeth (j{prev), (j{raw), j{prevbpp
    end.
    r=. r, prev=. x}.raw
  elseif. do.
    r=. r, prev=. iy
  end.
end.
sy$a.{~r
)
paeth=: 3 : 0
p=. +/ 1 1 _1 * y
y{~ (i.<./) |p-y
)
rave=: 1 : 0
:
raw=. m#0
for_i. i.#y do.
  raw=. raw, 256&| (i{y) + <. 2%~ (i{raw) + i{x
end.
m}.raw
)
readpng=: 3 : 0

if. USEQTPNG do.
  if. 0=# dat=. readimg_jqtide_ y do.
    'Qt cannot read PNG file' return.
  end.
  dat return.
elseif. USEJAPNG do.
  if. 0=# dat=. readimg_ja_ y do.
    'jandroid cannot read PNG file' return.
  end.
  dat return.
elseif. USEJNPNG do.
  if. 0=# dat=. readimg_ja_ y do.
    'jnet cannot read PNG file' return.
  end.
  dat return.
elseif. USEPPPNG do.
  if. 0=# dat=. readimg_pplatimg_ y do.
    'pplatimg cannot read PNG file' return.
  end.
  dat return.
end.
r=. readpnghdrall y
if. 2 = 3!:0 r do. return. end.
'nos dat'=. r
'width height bit color compression filter interlace'=. nos

if. 0~:filter do.
  'invalid filter' return.
end.
if. 0~:interlace do.
  'interlace PNGs not supported' return.
end.
if. (-.bit e. 1 2 4 8) do.
  'only 1 2 4 8 bit depth supported' return.
end.
dat=. fread y
ie=. I. 'IEND' E. dat
if. 0=#ie do. 'missing IEND' return. end.
dat=. ({.ie){. dat
if. 3=color do.
  ip=. I. 'PLTE' E. dat
  if. 0=#ip do. 'mssing PLTE' return. end.
  p=. {.ip-4
  len=. {.be32inv (p+i.4){dat
  crc=. ((len+8+p)+i.4){dat
  d=. (4+len){.(4+p)}.dat
  if. -. crc-:(be32 crc32 d) do. 'crc32 error' return. end.
  ipal=. fliprgb le32inv , ({:a.),~("1) _3]\ len{.(8+p)}.dat
end.

id=. I. 'IDAT' E. dat
if. 0=#id do. 'missing IDAT' return. end.

trns=. 0$0
if. color -.@e. 4 6 do.
  d=. ({.id){. dat
  if. #ir=. I. 'tRNS' E. d do.
    p=. {.ir-4
    len=. {.be32inv (p+i.4){dat
    s=. a.i. len{.(8+p)}.dat
    if. 0=color do.
      trns=. 8&gray2rgb 256 #. _2]\ s
    elseif. 2=color do.
      trns=. 256 #. _3]\ 256 #. _2]\ s
    elseif. 3=color do.
      trns=. (#ipal){.!.255 s
      ipal=. trns setalpha ipal
    end.
  end.
end.

id=. id-4
idat=. ''
p=. {.id
for_i. i.#id do.
  if. p>i{id do. continue. end.
  len=. {.be32inv ((i{id)+i.4){dat
  crc=. ((len+8+i{id)+i.4){dat
  d=. (4+len){.(4+i{id)}.dat
  if. -. crc-:(be32 crc32 d) do. 'crc32 error' return. end.
  idat=. idat, len{.(8+i{id)}.dat
  p=. p+len
end.
datalen=. 0
try.
  data=. datalen zlib_uncompress_jzlib_ idat
catch.
  'zlib uncompression error' return.
end.
if. color e. 0 4 do.
  if. (4=color) > bit e. 8 16 do.
    'only 8 and 16 bit grayscale can have alpha channel' return.
  end.
  if. 1=bit do.
    r=. (height,width)$ (setalpha)`(trns&transparent)@.(*#trns) 1&gray2rgb , #: a.i. , 1&rfilter (height,1+>.width%8) $ data
  elseif. 2=bit do.
    r=. (height,width)$ (setalpha)`(trns&transparent)@.(*#trns) 2&gray2rgb , 4 4 4 4 #: a.i. , 1&rfilter (height,1+>.width%4) $ data
  elseif. 4=bit do.
    r=. (height,width)$ (setalpha)`(trns&transparent)@.(*#trns) 4&gray2rgb , 16 16 #: a.i. , 1&rfilter (height,1+>.width%2) $ data
  elseif. 8=bit do.
    if. 0=color do.
      r=. (height,width)$ (setalpha)`(trns&transparent)@.(*#trns) 8&gray2rgb , a.i. , 1&rfilter (height,1+width) $ data
    else.
      r=. (height,width)$ (a.i.{.("1) a) setalpha 8&gray2rgb a.i. {:("1) a=. _2]\ , 2&rfilter (height,1+2*width) $ data
    end.
  elseif. do.
    'only 1 2 4 8 bit grayscale PNGs support' return.
  end.
elseif. 3=color do.
  if. 1=bit do.
    r=. (height,width)$ ipal{~ , #: a.i. , 1&rfilter (height,1+>.width%8) $ data
  elseif. 2=bit do.
    r=. (height,width)$ ipal{~ , 4 4 4 4 #: a.i. , 1&rfilter (height,1+>.width%4) $ data
  elseif. 4=bit do.
    r=. (height,width)$ ipal{~ , 16 16 #: a.i. , 1&rfilter (height,1+>.width%2) $ data
  elseif. 8=bit do.
    r=. (height,width)$ ipal{~ a.i. , 1&rfilter (height,1+width) $ data
  elseif. do.
    'only 1 2 4 8 bit palette PNGs support' return.
  end.
elseif. 6=color do.
  r=. (height,width)$ fliprgb le32inv , 4&rfilter (height,1+4*width) $ data
elseif. 2=color do.
  r=. (height,width)$ fliprgb (trns&transparent)^:(*#trns) le32inv , ({:a.),~("1) _3[\ , 3&rfilter (height,1+3*width) $ data
elseif. do.
  'invalid color type' return.
end.
r
)
transparent=: 4 : 0
((255 0){~({.x)=y) setalpha y
)
readpnghdr=: 3 : 0
r=. readpnghdrall y
if. 2 ~: 3!:0 r do.
  0 pick r
end.
)
readpnghdrall=: 3 : 0

try.
  dat=. 1!:11 (boxopen y),<0 29
  if. -. magic-:8{.dat do. 'not a PNG file' return. end.
  if. -. 0 0 0 13 -: a.i.4{.8}.dat do. 'not a PNG file' return. end.
  if. -. 'IHDR' -: 4{.12}.dat do. 'not a PNG file' return. end.
catch.
  dat=. 29{.y
  if. -. magic-:8{.dat do. 'file read error' return. end.
  if. -. 0 0 0 13 -: a.i.4{.8}.dat do. 'file read error' return. end.
  if. -. 'IHDR' -: 4{.12}.dat do. 'file read error' return. end.
end.

ihdr=. (16+i.13){dat
'bit color compression filter interlace'=. a.i.8}.ihdr

'width height'=. be32inv 8{.ihdr

(width,height,bit,color,compression,filter,interlace);dat
)
writepng=: 4 : 0

dat=. x
'file cmp'=. 2 {. (boxopen y), <_1

if3=. (3=#$dat) *. 3={:$dat
if. if3 do.
  dat=. setalpha 256&#. dat
end.

if. USEQTPNG do.
  dat writeimg_jqtide_ (>file);'png';'quality';_1
elseif. USEJAPNG do.
  if. 805> ".}.(i.&'/' {. ])9!:14'' do.
    dat writeimg_ja_ (>file);'png';'quality';_1
  else.
    writeimg_ja_ dat;(>file);'png'
  end.
elseif. USEJNPNG do.
  writeimg_jnet_ dat;(>file);'png'
elseif. USEPPPNG do.
  dat writeimg_pplatimg_ (>file)
elseif. do.
  (boxopen file) 1!:2~ cmp encodepng_unx dat
end.
)
encodepng_unx=: 4 : 0
cmp=. (_1=x){x,NOZLIB_jzlib_{6 2
wh=. |. sy=. $y

opaque=. *./ 255= , getalpha y
if. opaque do. y=. 0&setalpha y end.

pal=. ~. ,y
bit=. 1 2 4 8 16 {~ +/ 2 4 16 256 < # pal
if. (16>bit)*.((bit%~*/8,wh)>4*#pal) do.
  if. -.opaque do.
    alfa=. a.{~ getalpha pal
    pal=. 0&setalpha pal
    y=. 0&setalpha y
  end.
  y=. sy $ ,a.{~ pal i. y
  ipal=. , }:@Endian@(2&ic)"0 fliprgb pal
  if. 1=bit do.
    y=. a.{~ #.@(_8&(]\))"1 a.i.y
  elseif. 2=bit do.
    y=. a.{~ 4&#.@(_4&(]\))"1 a.i.y
  elseif. 4=bit do.
    y=. a.{~ 16&#.@(_2&(]\))"1 a.i.y
  end.
  if. 4 > (*/wh) % #pal do.
    lines=. , 1&ffilter0 y
  else.
    lines=. , 1&ffilter y
  end.
  if. opaque do.
    magic, (png_header wh,bit, 3), ('PLTE' png_chunk ipal), ('IDAT' png_chunk cmp&zlib_compress_jzlib_ lines), ('IEND' png_chunk '')
  else.
    magic, (png_header wh,bit, 3), ('PLTE' png_chunk ipal), ('tRNS' png_chunk alfa), ('IDAT' png_chunk cmp&zlib_compress_jzlib_ lines), ('IEND' png_chunk '')
  end.
else.
  if. opaque do.
    lines=. , 3&ffilter ,"2 }:@Endian@(2&ic)"0 fliprgb y
    magic, (png_header wh,8, 2), ('IDAT' png_chunk cmp&zlib_compress_jzlib_ lines), ('IEND' png_chunk '')
  else.
    lines=. , 4&ffilter ,"2 Endian@(2&ic)"0 fliprgb y
    magic, (png_header wh,8, 6), ('IDAT' png_chunk cmp&zlib_compress_jzlib_ lines), ('IEND' png_chunk '')
  end.
end.
)
png_chunk=: 4 : 0
(be32 #y), x, y, be32 crc32 x, y
)
png_header=: 3 : 0
'IHDR' png_chunk (,be32"0 [ 2{.y), ((2}.y), 0 0 0){a.
)
gray2rgb=: 4 : 0
if. 1=x do.
  <.y*16bffffff
else.
  ($y)$ 256#.("1) _3]\ 255<. (64 16 1{~2 4 8 i.x) * 3#,y
end.
)
ENDIAN=: ('a'={.2 ic a.i.'a')
be32=: ,@:(|."1)@(_4&(]\))^:ENDIAN@:(2&ic)
be32inv=: (_2&ic)@:(,@:(|."1)@(_4&(]\))^:ENDIAN)
le32=: ,@:(|."1)@(_4&(]\))^:(-.ENDIAN)@:(2&ic)
le32inv=: (_2&ic)@:(,@:(|."1)@(_4&(]\))^:(-.ENDIAN))
crc32=: ((_2&ic)@((4&{.)`(_4&{.)@.('a'~:{.2 ic a.i.'a'))@(3&ic))^:IF64 @: (((i.32) e. 32 26 23 22 16 12 11 10 8 7 5 4 2 1 0)&(128!:3))
signbyte=: ] - 256 * 127 <  ]
readpng_z_=: readpng_jpng_
writepng_z_=: writepng_jpng_
readpnghdr_z_=: readpnghdr_jpng_
