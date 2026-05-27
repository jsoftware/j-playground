coclass 'jbmp'

RGBSEQ=: 1
flipreadrgb=: endian^:RGBSEQ
flipwritergb=: endian^:RGBSEQ
BITMAPINFOHEADERDATA=: dfh&> cut ; <@(12&{.);._2 [ 0 : 0
42 4D       0   "BM" ID field (42h, 4Dh)
46 00 00 00 2   70 bytes (54+16) Size of the BMP file (54 bytes header + 16 bytes data)
00 00       6   Unused Application specific
00 00       8   Unused Application specific
36 00 00 00 10  54 bytes (14+40) Offset where the pixel array (bitmap data) can be found DIB Header
28 00 00 00 14  40 bytes Number of bytes in the DIB header (from this point)
02 00 00 00 18  2 pixels (left to right order) Width of the bitmap in pixels
02 00 00 00 22  2 pixels (bottom to top order) Height of the bitmap in pixels.  Positive for bottom to top pixel order.
01 00       26  1 plane Number of color planes being used
18 00       28  24 bits Number of bits per pixel
00 00 00 00 30  0 BI_RGB, no pixel array compression used
10 00 00 00 34  16 bytes Size of the raw bitmap data (including padding)
13 0B 00 00 38  2835 pixels/metre horizontal Print resolution of the image, 72 DPI × 39.3701 inches per metre yields 2834.6472
13 0B 00 00 42  2835 pixels/metre vertical
00 00 00 00 46  0 colors Number of colors in the palette
00 00 00 00 50  0 important colors 0 means all colors are important Start of pixel array (bitmap data)
00 00 FF    54  0 0 255 Red, Pixel (0,1)
FF FF FF    57  255 255 255 White, Pixel (1,1)
00 00       60  0 0 Padding for 4 byte alignment (could be a value other than zero)
FF 00 00    62  255 0 0 Blue, Pixel (0,0)
00 FF 00    65  0 255 0 Green, Pixel (1,0)
00 00       68  0 0 Padding for 4 byte alignment (could be a value other than zero)
)
readbmp=: 3 : 0

r=. readbmphdrall y
if. 2 = 3!:0 r do. return. end.
'nos dat'=. r
'bits rws cls off shdr'=. nos

pal=. off {. dat
dat=. off }. dat

if. bits e. 1 4 8 do.
  pal=. 256 #. flipreadrgb"1 a. i. _4 }: \ (shdr+14) }. pal
  dat=. , ((#~ ^.&256) 2^bits) #: a. i. dat
  pal {~ |. (rws,cls){.(rws,cls+(32%bits)|-cls) $ dat
elseif. bits=24 do.
  cl4=. 4 * >. (3*cls) % 4
  |. (rws,cls) {. 256 #. flipreadrgb"1 a.i. _3 [\"1 (rws,cl4) $ dat
elseif. 1 do.
  'only 1,4,8 and 24-bit bitmaps supported, this is ',(":bits),'-bit'
end.
)
readbmphdr=: 3 : 0
r=. readbmphdrall y
if. 2 ~: 3!:0 r do.
  3 {. 0 pick r
end.
)
readbmphdrall=: 3 : 0

try.
  dat=. 1!:1 boxopen y
  if. -. 'BM'-:2{.dat do. 'not a bitmap file' return. end.
catch.
  dat=. y
  if. -. 'BM'-:2{.dat do. 'file read error' return. end.
end.

toi=. 256&#.@(a.&i.)@(|."1)
bits=. toi 28 29 {dat

if. toi 30 31 32 33{dat do.
  'compressed format not supported' return.
end.

'off shdr cls rws'=. toi (10+i.4 4){dat
(bits,rws,cls,off,shdr);dat
)
writebmp=: 4 : 0

dat=. x
'file min'=. 2 {. (boxopen y), < 24*(IFIOS+.UNAME-:'Darwin')

if3=. (3=#$dat) *. 3={:$dat

sbmp=. (-if3) }. $dat
pal=. /:~ ~. ,/ dat
bit=. 4 8 24 {~ +/ 16 256 < # pal
bit=. min >. bit

if. bit e. 4 8 do.
  dat=. pal i. dat
  if. bit=4 do.
    dat=. 16 #. _2[\"1 dat
  else.
    pal=. 256 {. pal
  end.
  spal=. #pal
  if. -. if3 do.
    pal=. 256 256 256 #: pal
  end.
  pal=. flipwritergb"1 pal
  pal=. , a. {~ pal ,. 0
  xsbmp=. ($dat) + 0 1 * 4|-$dat
  bmp=. xsbmp{.dat
else.
  pal=. ''
  spal=. 0
  if. -.if3 do.
    dat=. 256 256 256 #: dat
  end.
  dat=. flipwritergb"1 dat
  bmp=. ,"2 dat
  bmp=. ((1 4)* >. ($bmp) % (1 4)) {. bmp
end.

bmp=. ,|. bmp{ a.
sdat=. $bmp

j=. (|.sbmp),(256 #. 0, bit, 0 1),0,sdat,2835 2835,2#spal
b=. (54+(4*spal)+sdat),0,(54+4*spal),40,j
head=. 'BM',,a.{~,|."1 (4#256)#:b

(head,pal,bmp) 1!:2 boxopen file
)
readbmp_z_=: readbmp_jbmp_
readbmphdr_z_=: readbmphdr_jbmp_
writebmp_z_=: writebmp_jbmp_
