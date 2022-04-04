coclass 'jzlib'

zlib=: IFUNIX{::'zlib1.dll';unxlib 'z'
NOZLIB=: 0=(zlib,' zlibVersion >',(IFWIN#'+'),' x')&cd ::0:''
zcompress2=: (zlib, ' compress2  ',(IFWIN#'+'),' i *c *x *c x i')&cd
zuncompress=: (zlib, ' uncompress  ',(IFWIN#'+'),' i *c *x *c x')&cd
MAX_DEFLATE=: 16bffff

DYNAMIC=: 1
MAXSTATIC=: 100
BLKSIZE=: 65536
deflate=: 4 : 0
'wrapper level'=. 2{.(boxopen x),<NOZLIB{6 1
BTYPE=. 1
if. (0=level) +. 0=#y do. BTYPE=. 0
elseif. 256>:#y do.
  if. (#y) = #~.y do.
    BTYPE=. 0
  end.
end.
if. 0=BTYPE do.
  wrapper deflate_unc y
  return.
end.
lz=. level lz_enc y
if. MAXSTATIC < #lz do.
  numblk=. >.(#lz)%BLKSIZE
  BTYPE=. DYNAMIC{1 2
  numblk=. #lx=. ~. (#lz),~ t1{~ (#~ (#t1)&>) [ (t1=. I. lz < 256) I. BLKSIZE*1+i.numblk
else.
  numblk=. 1
  lx=. ,#lz
end.
blk=. 0
of=. , |."1 (8#2) #: a.i. wrapper
i=. 0
while. blk<numblk do.
  of=. of, BFINAL=. blk=numblk-1
  of=. of, (BTYPE-1){1 0,:0 1
  assert. 256>i{lz
  if. 2=BTYPE do.
    bs=. blk{ 0, lx
    bl=. blk{ - 2 -/\ 0, lx
    assert. bl>0
    assert. i=bs
    data=. (bs+i.bl){lz

    lit_data=. (A1=. i.286), (286>data)#data
    F1=. <: #/.~ lit_data
    F1=. (1) 256}F1
    whilst. 15<>./bits1 do.
      bits1=. F1 bitlen A1
      minbits=. <./F1-.0
      F1=. (1+minbits) (I.minbits=F1) } F1
    end.
    bits1=. (- +/*./\0=|.bits1)}.bits1
    bits1=. (257&{.)^:(257>#bits1) bits1
    lit_code=. /:~ def_code bits1

    dist_data=. (A2=. i.32), 300 -~ ((329>:data)*.(300<:data))#data
    F2=. <: #/.~ dist_data
    if. 0=+/0~:F2 do.
      bits2=. ,0
      dist_code=. ,:0 0 0
    else.
      if. 1=+/0~:F2 do.
        if. 1={.0~:F2 do.
          F2=. 1 (1)}0~:F2
        else.
          F2=. 1 (0)}0~:F2
        end.
      end.
      whilst. 15<>./bits2 do.
        bits2=. F2 bitlen A2
        minbits=. <./F2-.0
        F2=. (1+minbits) (I.minbits=F2) } F2
      end.
      bits2=. (- +/*./\0=|.bits2)}.bits2
      dist_code=. /:~ def_code bits2
    end.
    litdist=. bits1,bits2
    assert. 16> litdist
    cls=. repeatcodelength litdist
    litdista=. (A3=. i.19), (19>cls)#cls
    F3=. <: #/.~ litdista
    whilst. 7<>./bits3 do.
      bits3=. F3 bitlen A3
      minbits=. <./F3-.0
      F3=. (1+minbits) (I.minbits=F3) } F3
    end.
    order=. 16 17 18 0 8 7 9 6 10 5 11 4 12 3 13 2 14 1 15
    bits3a=. order{bits3
    bits3a=. (- +/*./\0=|.bits3a)}.bits3a
    bits3a=. (4&{.)^:(4>#bits3a) bits3a
    clen_code=. /:~ def_code bits3
    clsh=. clen_code encodecodelength cls

    HLIT=. #bits1
    HDIST=. #bits2
    HCLEN=. #bits3a

    hdr=. |. (5#2) #: HLIT-257
    hdr=. hdr, |. (5#2) #: HDIST-1
    hdr=. hdr, |. (4#2) #: HCLEN-4
    hdr=. hdr, , |.("1) (3#2) #:("1 0) bits3a
    hdr=. hdr, clsh

    of=. of,hdr
  end.
  assert. 256>:i{lz [ 'first symbol is not a literal'
  while. i< blk{lx do.
    code=. i{lz
    assert. 285>:code [ 'not literal or length'
    assert. 256~:code [ 'EOB is illegal during encoding'
    of=. of, (lit_code&huff_encode)`(fixed_huffman_code&huff_encode)@.(1=BTYPE) code
    i=. i+1

    if. 257 <: code do.
      ix=. code - 257
      assert. (1000 <: i{lz) *. (2000 > i{lz)
      extra=. (i{lz) - 1000
      i=. i+1
      if. bit=. (<ix,0){lz_length do.
        of=. of, |. (bit#2) #: extra
      end.
      assert. (300 <: i{lz) *. (329 >: i{lz)
      code=. (i{lz) - 300
      ix=. code
      i=. i+1
      assert. (2000 <: i{lz)
      extra=. (i{lz) - 2000
      i=. i+1

      of=. of, (dist_code&huff_encode)`((5#2)&#:)@.(1=BTYPE) code
      if. bit=. (<ix,0){lz_distance do.
        of=. of, |. (bit#2) #: extra
      end.
    end.
  end.
  of=. of, (lit_code&huff_encode)`(fixed_huffman_code&huff_encode)@.(1=BTYPE) 256
  blk=. 1+blk
end.
a.{~ #.@|.("1) _8[\ of
)
repeatcodelength=: 3 : 0
first=. 1, (}.y) ~: }:y
rcode=. first # y
rcnt=. first #;.1 y
cls=. 0$0
for_i. i.#rcode do.
  if. 3>i{rcnt do.
    cls=. cls, (i{rcnt)#i{rcode
  else.
    if. 0~:i{rcode do.
      cls=. cls, i{rcode
      for_j. _6#\ 1#~<:i{rcnt do.
        if. j>2 do.
          cls=. cls, 16, 100+j-3
        else.
          cls=. cls, j#i{rcode
        end.
      end.
    else.
      for_j. _138#\ 1#~i{rcnt do.
        if. j>10 do.
          cls=. cls, 18, 100+j-11
        else.
          for_k. _10#\ 1#~j do.
            if. k>2 do.
              cls=. cls, 17, 100+k-3
            else.
              cls=. cls, k#0
            end.
          end.
        end.
      end.
    end.
  end.
end.
cls
)
encodecodelength=: 4 : 0
z=. 0$0
i=. 0
while. i<#y do.
  assert. 19>i{y
  z=. z, x&huff_encode i{y
  if. 16=i{y do.
    i=. i+1
    z=. z, |. (2#2) #: 100 -~ i{y
  elseif. 17=i{y do.
    i=. i+1
    z=. z, |. (3#2) #: 100 -~ i{y
  elseif. 18=i{y do.
    i=. i+1
    z=. z, |. (7#2) #: 100 -~ i{y
  end.
  i=. i+1
end.
z
)
huff_encode=: 4 : 0
'bit code sym'=. x{~ ({:"1 x) i. y
(bit#2)#:code
)
deflate_unc=: 4 : 0
segments=. (-MAX_DEFLATE) <\ y
blocks=. x, ; 0&deflate_unc_block&.> }:segments
blocks, 1&deflate_unc_block >@{:segments
)
deflate_unc_block=: 4 : 0
n=. #y
(x{a.),(Endian 1&ic n),(Endian 1&ic 0 (26 b.) n), y
)

NB.! Essays/Huffman Coding - J Wiki
NB.! http://code.jsoftware.com/wiki/Essays/Huffman%20Coding
NB.! Contributed by RogerHui.

hc=: 4 : 0
if. 1=#x do. y
else. ((i{x),+/j{x) hc (i{y),<j{y [ i=. (i.#x) -. j=. 2{./:x end.
)

hcodes=: 4 : 0
assert. x -:&$ y
assert. (0<:x) *. 1=#$x
assert. 1 >: L.y
w=. ,&.> y
assert. w -: ~.w
t=. 0 {:: x hc w
((< S: 0 t) i. w) { <@(1&=)@; S: 1 {:: t
)
NB.! from J Programming forum
NB.! contributed by Raul Miller

bl_count=: 3 :0
0,}.<:#/.~(,~ [: i. 1 + >./)y
)

start_vals=: +:@+/\.&.|.@}:@,~&0
find_codes=: 3 :0
b=. bl_count y
v=. start_vals b
n=. /:~ ~.y-.0
o=. ;({./.~ /:~ (</. i.@#)) y-.0
c=. ;<"1&.>n (([#2:) #: ])&.> (*b)#v+&.>i.&.>b
c /: o
)
def_code=: 3 :0
assert. 1<+/0~:y
b=. bl_count y
v=. start_vals b
n=. /:~ ~.y-.0
o=. ;({./.~ /:~ (</. i.@#)) y-.0
c=. ;n,.&.>(*b)#v+&.>i.&.>b
z=. (I.0~:y),.~ c /: o
test_rule z
z
)
bitlen=: 4 :0
assert. 1<+/0~:x
b=. 0~:x
b #inv #@>(b#x) hcodes b#y
)
test_rule=: 3 : 0
for_i. ~. {."1 y1=. y/:({:"1 y) do.
  s=. (i={."1 y1) # (1{"1 y1)
  assert. (({.s)+i.#s) -: s
end.
)
fixed_huffman_code=: /:~ def_code (144#8),(112#9),(24#7),(8#8)
lz_length=: 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 0
lz_length=: lz_length ,. 3 4 5 6 7 8 9 10 11 13 15 17 19 23 27 31 35 43 51 59 67 83 99 115 131 163 195 227 258
lz_distance=: 0 0 0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13
lz_distance=: lz_distance ,. 1 2 3 4 5 7 9 13 17 25 33 49 65 97 129 193 257 385 513 769 1025 1537 2049 3073 4097 6145 8193 12289 16385 24577
inflate=: 3 : 0
of=. ''
huff_buf=: , |."1 (8#2) #: a.i. y

BFINAL=. 0
bf=. 0
bf_end=. 8*#y
while. (-.BFINAL)*.bf_end> >.&.(%&8) bf do.
  BFINAL=. 1=0{huff_buf
  bf=. 1+bf
  BTYPE=. #.(bf+i._2){huff_buf
  bf=. 2+bf
  if. 0=BTYPE do.
    bf=. >.&.(%&8) bf
    len=. #.(bf+i._16){huff_buf
    assert. (-.(16+bf+i._16){huff_buf)=(bf+i._16){huff_buf [ 'uncompressed block length error'
    of=. of, (4+(bf%8)+i.len){y
    bf=. 32+bf+8*len
  elseif. BTYPE e. 1 2 do.
    if. 2=BTYPE do.
      HLIT=. 257 + 2#.(bf+i._5){huff_buf
      HDIST=. 1 + 2#.(5+bf+i._5){huff_buf
      HCLEN=. 4 + 2#.(10+bf+i._4){huff_buf
      clen=. 19#0
      order=. 16 17 18 0 8 7 9 6 10 5 11 4 12 3 13 2 14 1 15
      clen=. (2#. |.("1) _3]\ (14+bf+i.3*HCLEN){huff_buf) (HCLEN{.order)}clen
      clen_code=: /:~ def_code clen
      bf=. bf + 14 + 3 * HCLEN
      lit=. 0
      litdist=. 0$0
      while. (HLIT+HDIST)>#litdist do.
        'lit bf'=. clen_code&huff_decode bf
        if. lit<16 do.
          litdist=. litdist, lit
        elseif. 16=lit do.
          litdist=. litdist, (3+2#.(bf+i._2){huff_buf)#{:litdist
          bf=. bf+2
        elseif. 17=lit do.
          litdist=. litdist, (3+2#.(bf+i._3){huff_buf)#0
          bf=. bf+3
        elseif. 18=lit do.
          litdist=. litdist, (11+2#.(bf+i._7){huff_buf)#0
          bf=. bf+7
        end.
      end.
      assert. 1<#HLIT{.litdist
      lit_code=. /:~ def_code HLIT{.litdist
      if. 141=+/0~:HLIT{.litdist do.
      end.
      if. 1<#HLIT}.litdist do.
        dist_code=. /:~ def_code HLIT}.litdist
      else.
        dist_code=. ,:0 0 0
      end.
    end.
    lit=. 0
    while. 256~:lit do.
      if. 1=BTYPE do.
        'lit bf'=. fixed_huffman_code&huff_decode bf
      else.
        'lit bf'=. lit_code&huff_decode bf
      end.
      if. 256>lit do.
        of=. of, lit{a.
      end.
      if. 257>lit do. continue. end.
      'b l1'=. (lit-257){lz_length
      l2=. 0
      if. b do. l2=. 2#.(bf+i.-b){huff_buf end.
      len=. l1 + l2
      bf=. bf+b
      if. 1=BTYPE do.
        dist=. 2#.(bf+i.5){huff_buf
        bf=. bf+5
      else.
        'dist bf'=. dist_code&huff_decode bf
      end.
      'b l1'=. lz_distance {~ dist
      l2=. 0
      if. b do. l2=. 2#.(bf+i.-b){huff_buf end.
      dist=. l1 + l2
      bf=. bf+b
      of=. of, len$(-dist){.of
    end.
  elseif. do.
    assert. 0 [ 'invalid BTYPE'
  end.
end.
huff_buf=: ''
of
)
huff_decode=: 4 : 0
for_bit. ~.{."1 x do.
  t=. }."1 (bit={."1 x)#x
  if. (#t) > ix=. (0{"1 t) i. 2#.(y+i.bit){huff_buf do.
    (ix{1{"1 t),y+bit return.
  end.
end.
assert. 0 [ 'huff_decode'
)
lz_enc=: 4 : 0
if. (0=x) +. 6>#y do. a.i. y return. end.
largewindow=. x>6
if. 1=x do.
  if. 0= textonly=. istext y do. a.i. y return. end.
end.
prelook=. largewindow{1024 4096
sliding=. largewindow{4096 32768
maxmatch=. 258

h=. hash3 y
of=. a.i. 2{.y
i=. 2
win=. 0
winp=. 2
winq=. 2
h1x=. h1=. h0=. 0$0
h0i=. h0&i:
while. (_2+#y)>i do.
  if. (i-winq)>:#h1 do.
    if. (sliding-prelook) > slen=. (#h0)+(#h1) do.
      h0=. h0, (winq+i.#h1){h
    else.
      h0=. (-(sliding-prelook)){.i{.h
      winp=. i-(sliding-prelook)
    end.
    h0i=. h0&i:
    h1=. prelook&{.^:(prelook<#) i}.h
    h1x=. h1 i: prelook&{.^:(prelook<#) i}.h
    winq=. i
  end.
  fnd=. 0
  if. (#h1x)> ix=. (i-winq){h1x do.
    if. ix<i-winq do. ix=. winq+ix [ fnd=. 1
    else.
      if. (#ht) > ixx=. (ht=. (i-winq){.h1) i: i{h do.
        ix=. winq+ixx [ fnd=. 1
      end.
    end.
  end.
  if. 0=fnd do.
    if. (#h0) > ix=. h0i i{y do.
      ix=. winp + ix [ fnd=. 1
    end.
  end.
  j=. 0
  if. fnd do.
    lookahead=. i}.y
    history=. ix}.i{.y
    j=. ((#y)-i) <. +/ *./\ (maxmatch{.lookahead)=maxmatch $ history
  end.
  if. j>2 do.
    of=. of, (enclength j), encdistance i-ix
    i=. i+j
  else.
    of=. of, a.i. i{y
    i=. i+1
  end.
end.
of, a.i. (i-#y){.y
)

hash3=: 3 : 0
a=. , _2&ic("1) _4{.("1) _3]\ (>.&.(%&3)#y){.y
b=. , _2&ic("1) _4{.("1) _3]\ (>.&.(%&3)#y){.}.y
c=. , _2&ic("1) _4{.("1) _3]\ (>.&.(%&3)#y){.2}.y
(#y){. , a,.b,.c
)
enclength=: 3 : 0
ix=. <: +/({:"1 lz_length)<:y
code=. 257 + ix
ex=. y-(<ix,1){lz_length
assert. (0<:ex)*.(30>:ex)
code, 1000+ex
)
encdistance=: 3 : 0
ix=. <: +/({:"1 lz_distance)<:y
code=. 300 + ix
ex=. y-(<ix,1){lz_distance
assert. (0<:ex)*.(8191>:ex)
code, 2000+ex
)
install=: 3 : 0
if. -. IFWIN do. return. end.
require 'pacman'
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/', z=. 'winlib/',(IF64{::'x86';'x64'),'/zlib1.dll'
if. rc do.
  smoutput 'unable to download: ',z return.
end.
(<jpath'~bin/zlib1.dll') 1!:2~ 1!:1 <p
1!:55 ::0: <p
smoutput 'done'
EMPTY
)
ENDIAN=: ('a'={.2 ic a.i.'a')
be32=: ,@:(|."1)@(_4&(]\))^:ENDIAN@:(2&ic)
be32inv=: (_2&ic)@:(,@:(|."1)@(_4&(]\))^:ENDIAN)
adler32=: [: ({: (23 b.) 16&(33 b.)@{.) _1 0 + [: ((65521 | +)/ , {.) [: (65521 | +)/\. 1 ,~ a. i. |.
istext=: 3 : 0
if. +./(a.{~9 10 13, 32+i.224) e. y do.
  if. 0=+./(a.{~0 1 2 3 4 5 6, 14+i.18) e. y do.
    1 return.
  end.
end.
0
)
zlib_encode_j=: 6&$: : (4 : 0)
(((16b78 1{a.);x) deflate y), be32 adler32 y
)
zlib_decode_j=: 0&$: : (4 : 0)
assert. 16b78=a.i.{.y [ 'zlib header not16b78'
assert. 0=31|256#. |. a.i.|.2{.y [ 'zlib header checksum error'
assert. 0=2{(8#2)#:a.i.1{y [ 'zlib header FDICT not supported'
of=. inflate _4}.2}.y
assert. (_4{.y) -: be32 adler32 of
of
)
zlib_encode_so=: 6&$: : (4 : 0)
len=. ,12+>.1.001*#y
buf=. ({.len)$' '
assert. 0= >@{. cdrc=. zcompress2 buf ; len ; y ; (#y) ; x
'buf len'=. 1 2{cdrc
({.len){.buf
)

zlib_decode_so=: 0&$: : (4 : 0)
if. 0=x do.
  datalen=. , f=. 2*#y
else.
  datalen=. , x
end.
data=. ({.datalen)#{.a.
if. 0~: rc=. >@{. cdrc=. zuncompress data;datalen;y;#y do.
  if. 0~:x do.
    assert. 0 [ 'zlib uncompression error'
  end.
  while. rc e. _5 do.
    datalen=. , f=. 2*f
    data=. ({.datalen)#{.a.
    rc=. >@{. cdrc=. zuncompress data;datalen;y;#y
  end.
  if. 0~:rc do.
    smoutput rc
    assert. 0 [ 'zlib uncompression error'
  end.
end.
({.2{::cdrc){.1{::cdrc
)
zlib_compress=: zlib_encode_so`zlib_encode_j@.NOZLIB
zlib_uncompress=: zlib_decode_so`zlib_decode_j@.NOZLIB
zlib_compress_z_=: zlib_compress_jzlib_
zlib_uncompress_z_=: zlib_uncompress_jzlib_
