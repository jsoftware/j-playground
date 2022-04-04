// lab "DLL: writing and using a DLL"

#ifdef _WIN32
#include <windows.h>
int APIENTRY DllMain (HINSTANCE hDLL, DWORD dwReason, LPVOID lpReserved)
{
	return TRUE;
}
#else
#include <string.h>
#define __stdcall
#define __cdecl
#endif

#ifdef _MSC_VER
#define CDPROC
#elif defined(__GNUC__)
#define CDPROC __attribute__ ((visibility ("default")))
#else
#define CDPROC
#endif

int val=0; char data[]="static data"; // globals

// __stdcall - windows API DLL calling convention
CDPROC void	__stdcall incval(){++val;}
CDPROC int		__stdcall getval(){return val;}
CDPROC short	__stdcall incs(short s){return ++s;}
CDPROC char	__stdcall incc(char c){return ++c;}
CDPROC int		__stdcall inci(int i){return ++i;}
CDPROC float	__stdcall incf(float f){return ++f;}
CDPROC double	__stdcall incd(double d){return ++d;}
CDPROC int		__stdcall addi(int x, int y){return x+y;} 

CDPROC int		__stdcall addvi(int n, int* p){ int r=0;
	for(int i=0; i<n; ++i) r+=*p++; return r;}

CDPROC void	__stdcall incvi(int n, int* p){
	for(int i=0; i<n; ++i) *p++ +=1;}

CDPROC void	__stdcall incvs(int n, short* p){
	for(int i=0; i<n; ++i) *p++ +=1;}

CDPROC void	__stdcall getdata(char* c) {strcpy(c,data);}
CDPROC char*	__stdcall getdatap(){return data;}
CDPROC void	__stdcall getdatapx(char* *p){ *p = data;}

// __cdecl - default C calling convention
// __cdecl is the alternate (+ cd flag) calling convention
CDPROC int		altinci(int i){return ++i;}
