//these are stubs needed to run under WASI with wasmer or wasmitme

#ifdef WASMER
//not sure where this comes from
void setTempRet0(int foo) { }


int _dlopen_js(int a) {
    return 1;
}

int _dlsym_js(int a, int b) {
    return 1;
}

int __syscall_dup(int a) {
    return 1;
}

int __syscall_access(int a, int b) {
    return 1;
}
int __syscall_getdents64(int a) {
    return 1;
}

int __syscall_chdir(int a) {
	printf("in chdir");
	return 1;
}

int __syscall_mkdir(int a) {
    return 1;
}

int __syscall_rmdir(int a) {
    return 1;
}

int __syscall_fstat64(int a) {
	printf("in fstat64");
	return 1;
}
	
int __syscall_stat64(int a) {
	printf("in stat64\n");
    return 1;
}

int __syscall_fstatat64(int a) {
	printf("in fstata64\n");
    return 1;
}
int __syscall_pipe(int a) {
    return 1;
}

int __syscall_getcwd(int a, int b) {
	printf("in getcwd");
	return 1;
}

int __syscall_chmod(int a, int b) {
    return 1;
}

int __syscall_lstat64(int a, int b) {
	printf("in lstat64\n");
    return 1;
}


int __assert_fail(int a, int b, int c) {
    return 1;
}





int __localtime_r(int a, int b, int c) {
    return 1;
}

int __clock_gettime(int a, int b, int c) {
    return 1;
}
/*
int __syscall_munmap(int a, int b, int c) {
    return 1;
}

int __syscall_open(int a, int b, int c) {
    return 1;
}

int __syscall_ioctl(int a, int b, int c) {
    return 1;
}

int __syscall_fcntl64(int a, int b, int c) {
    return 1;
}

int emscripten_resize_heap(int a, int b, int c) {
    return 1;
}

int emscripten_memcpy_big(int a, int b, int c) {
    return 1;
}

int emscripten_get_now(int a, int b, int c) {
    return 1;
}
*/

int __syscall_unlink(int a, int b) {
    return 1;
}

int _emscripten_throw_longjmp(int a, int b) {
    return 1;
}
/*
size_t __stdio_read(FILE *f, const unsigned char *buf, size_t len, int z) {
    return 1;
}
int __stdio_close(FILE *f) {
    return 1;
}

off_t __stdio_seek(FILE *_f, off_t _offset, int _value) {
    return 1;
}

size_t __stdout_write(FILE *f, const unsigned char *buf, size_t len) {
  return 1;
}
*/
int system(const char *c) { }
int invoke_iii(int, int, int) { }
int invoke_iiii(int, int, int, int) { }
int invoke_iiiii(int, int, int, int, int) { }
int invoke_iv(int, int, int, int, int) { }
int invoke_vij(int, int, int, int, int) { }
int invoke_ji(int, int, int, int, int) { }
int invoke_iiiji(int, int, int, int, int) { }
int invoke_iiiiji(int, int, int, int, int) { }
int invoke_iiiij(int, int, int, int, int) { }
int invoke_iiji(int, int, int, int, int) { }
int invoke_vi(int, int, int, int, int) { }
int invoke_vii(int, int, int, int, int) { }
int invoke_ii(int, int, int, int, int) { }
int invoke_iiiiii(int, int, int, int, int) { }


void emscripten_notify_memory_growth() { }
//int fd_close(int v) { return 0; }
int getTempRet0() { return 0; }
void exit() { return; }
void gettimeofday() { return; }
void clock() { return; }
void time() { return; }

#endif
