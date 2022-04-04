
USEQTPNG_jpng_=: USEJAPNG_jpng_=: USEJNPNG_jpng_=: USEPPPNG_jpng_=: 0

load 'graphics/png bmp'     NB. require toucan.bmp for testing

T=. readbmp jpath'~addons/graphics/bmp/toucan.bmp'
T writepng jpath'~temp/toucan.png'
T -: readpng jpath'~temp/toucan.png'

(T=. setalpha i.320 320) writepng jpath'~temp/test1.png'
T -: readpng jpath'~temp/test1.png'
