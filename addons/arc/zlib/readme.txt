This zlib addon requires zlib binary library to encode and decode
zlib/deflate streams.  When zlib binary library is un-available,
it will use pure J scripts which is much less efficient.

For Linux, zlib should already be installed by default in most distros.
If not, install using (debian and its derivatives) in terminal.

$ sudo aptitude install zlib1g

For Windows, type the following in a J session to download and install
zlib dll from Jsoftware server.

load 'arc/zlib'
install_jzlib_''
load 'arc/zlib'
