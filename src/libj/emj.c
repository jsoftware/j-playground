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

/* J calls for output */
void _stdcall Joutput(J jt,int type, char* s)
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


char* _stdcall Jinput(J jt,char* prompt){
	return Jinput_stdio(prompt);
}



int main( void ) {
  void* callbacks[] = {Joutput,0,Jinput,0,(void*)SMCON}; int type;

 jt=JInit(); //((JInitType)JInit)();
 JSM(jt, callbacks);
 //jt=jeload(callbacks);
  printf("\n%d\n", JDo(jt, "i.30"));
// if(!jt){char m[1000]; jefail(m), fputs(m,stdout); exit(1);}
//   printf( "Enter two numbers: \n\n" );
   //scanf( "%lf%lf", &x, &y );
   //printf( "The arithmetic-geometric mean is %lf\n", agm(x, y) );
   return 0;
}