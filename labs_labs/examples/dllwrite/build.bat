call "\Program Files (x86)\Microsoft Visual Studio 12.0\vc\bin\x86_amd64\vcvarsx86_amd64.bat"
call nmake -f makefile_win x64=1 clean
call nmake -f makefile_win x64=1
call nmake -f makefile_win x64=1 clean
