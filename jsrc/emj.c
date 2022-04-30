#include<stdio.h>
#include "j.h"
#include "jeload.h"
#include "wasm_stubs.h"


J jt;

static char input[30000];

//there is probably a better way to do this
static char output[30000];

// function for calling from HTML
// var jdo = Module.cwrap('em_jdo','string',['string'])
// jdo('1+1')
char* em_jdo( char *cmd ) {
  JDo(jt, cmd);
  return output;
}

void em_jsetstr(char *var, char *val) {
	I type=2,jr=1,*jl=malloc(sizeof(I));*jl=strlen(val);
	I r = JSetM(jt,var,&type,&jr,(I*)&jl,(I*)&val);
}

//inspiration from https://github.com/jitwit/jpl-mode/blob/5c179ffb94c30a561835456365e0b09aa01db337/jpl-module.c
#define DO(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}
static I cardinality (I r,I s) { I c=1;DO(r,c*=((I*)s)[i]);R c; }
char* em_jgetstr(char *var) {
	I jr,jtype, js;
	char *jd;
	I r = JGetM(jt,var,&jtype,&jr,&js,&jd);
	 I c=cardinality(jr,js);
	 jd[c]='\0';
	return jd;
}


/* J calls for output */
void _stdcall Joutput(JS jt,int type, C* s)
{
  
  strncpy(output, s, sizeof(output));

  //drop 1 character to remove the trailing \n
  int len = strlen(s);
  output[len-1] = '\0';  
  printf("%s", s);
}

char* Jinput_stdio(char* prompt)
{
	fputs(prompt,stdout);
	fflush(stdout); /* windows emacs */
	if(!fgets(input, sizeof(input), stdin))
	{
		/* unix eof without readline */
		return "2!:55''";
	}
	return input;
}


C* _stdcall Jinput(JS jt,C* prompt){
	return Jinput_stdio(prompt);
}


//extern static void Initializer(int argc, char** argv, char** envp);

int main( void ) {
  void* callbacks[] = {Joutput,0,Jinput,0,(void*)SMCON}; int type;


 jt=JInit(); //((JInitType)JInit)();
 JSM(jt, callbacks);
 //jt=jeload(callbacks);
// if(!jt){char m[1000]; jefail(m), fputs(m,stdout); exit(1);}
//   printf( "Enter two numbers: \n\n" );
   //scanf( "%lf%lf", &x, &y );
   //printf( "The arithmetic-geometric mean is %lf\n", agm(x, y) );
#if HTML
 //load stdlib
 em_jdo("(0!:0) <'jlibrary/system/main/stdlib.ijs'");
 em_jdo("(0!:0) <'emj.ijs'");
#endif
#ifdef TESTS
 em_jdo("smoutput 1");
 printf("hello world\n");
 em_jdo("(0!:0) <'testga.ijs'");
 exit(1);
#endif
   return 0;
}
