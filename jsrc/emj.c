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

#define FWRITE_O          "wb"

// 1!:2
F2(jtjfwrite){B b;F f;
 F2RANK(RMAX,0,jtjfwrite,DUMMYSELF);
 if(BOX&AT(w)){ASSERT(1>=AR(a),EVRANK); ASSERT(!AN(a)||AT(a)&LIT+C2T+C4T,EVDOMAIN);}
 RE(f=stdf(w));
 if(2==(I)f){jtjpr((J)((I)jt|MTYOFILE),a); R a;}  // this forces typeout, with NOSTDOUT off
 if(4==(I)f){R (U)AN(a)!=fwrite(CAV(a),sizeof(C),AN(a),stdout)?jerrno():a;}
 if(5==(I)f){R (U)AN(a)!=fwrite(CAV(a),sizeof(C),AN(a),stderr)?jerrno():a;}
 if(b=!f)RZ(f=jope(w,FWRITE_O)) else RE(vfn(f)); 
 //wa(f,0L,a); 
 if(b)fclose(f);else fflush(f);
 RNE(mtm);
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
   return 0;
}
