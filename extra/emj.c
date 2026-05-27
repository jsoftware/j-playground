#include <stdio.h>
#include <emscripten.h>
#include "j.h"
#include "jeload.h"
#include "wasm_stubs.h"

EMSCRIPTEN_KEEPALIVE
int myFunction(int x) {
  printf("Hello from WebAssembly! x = %d\n", x);
  return x * x;
}

EMSCRIPTEN_KEEPALIVE
int add(int a, int b) {
  return a + b;
}

JS jt;

const int MAX_OUTPUT_SIZE=30000;

static char input[30000];
//there is probably a better way to do this
static char output[30000];

int outputPtr=0;

// function for calling from HTML
// var jdo = Module.cwrap('em_jdo','string',['string'])
// jdo('1+1')
char* em_jdo( char *cmd ) {

  //JDo will call Joutput to create output string in global output variable
  outputPtr=0;

  //clear output
  output[outputPtr] = '\0';

  //execute the J cmd
  JDo(jt, cmd);

  //null terminate the output
  output[outputPtr-1] = '\0';
  return output;
}

// ---------------------------------------------------------------------
int em_jinit() {
  void* callbacks[] = {Joutput,0,Jinput,0,(void*)SMCON}; int type;
  jt=JInit(); //((JInitType)JInit)();
  JSM(jt, callbacks);
  return 0;
}

// ---------------------------------------------------------------------
void em_jsetstr(char *var, char *val) {
  I type=2,jr=1,*jl=malloc(sizeof(I));*jl=strlen(val);
  I r = JSetM(jt,var,&type,&jr,(I*)&jl,(I*)&val);
}

// ---------------------------------------------------------------------
//inspiration from https://github.com/jitwit/jpl-mode/blob/5c179ffb94c30a561835456365e0b09aa01db337/jpl-module.c
#define DOS(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}
static I cardinality (I r,I s) { I c=1;DOS(r,c*=((I*)s)[i]);R c; }
char* em_jgetstr(char *var) {
  I jr,jtype, js;
  char *jd;
  I r = JGetM(jt,var,&jtype,&jr,&js,(I*)&jd);
   I c=cardinality(jr,js);
   jd[c]='\0';
  return jd;
}

// ---------------------------------------------------------------------
/* J calls for output */
void _stdcall Joutput(JS jt,int type, C* s)
{
  char *p = s;
  while(*p != 0 && outputPtr < MAX_OUTPUT_SIZE) {
    output[outputPtr++] = *p;
    p++;
  }
  printf("%s", s);
}

// ---------------------------------------------------------------------
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

// ---------------------------------------------------------------------
int main() {
  printf("Module initialized!\n");
  return 0;
}

//extern static void Initializer(int argc, char** argv, char** envp);

//int main( int argc, char *argv[] ) {
  //void* callbacks[] = {Joutput,0,Jinput,0,(void*)SMCON}; int type;

 //jt=JInit(); //((JInitType)JInit)();
 //JSM(jt, callbacks);

//if (argc>1 && strcmp(argv[1],"TEST") == 0)  {
  //em_jdo("(0!:11) <'jlibrary/system/main/stdlib.ijs'");
  //em_jdo("(0!:0) <'testga.ijs'");
//}
//#if HTML
 //em_jdo("smoutput html");
 //printf("at html\n");
 //em_jdo("(0!:0) <'jlibrary/system/main/stdlib.ijs'");
 //em_jdo("(0!:0) <'emj.ijs'");
//#endif
//#ifdef TESTS
 //em_jdo("smoutput 1");
 //printf("hello world\n");
 //em_jdo("(0!:0) <'testga.ijs'");
 //exit(1);
//#endif
 //return 0;
//}
