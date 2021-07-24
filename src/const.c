
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#define PR_CONST_D(C) printf("#define " #C " %#x\n", (unsigned)(C));

int main(void)
{
	puts("");
	PR_CONST_D(O_CREAT);
	PR_CONST_D(O_APPEND);
	PR_CONST_D(O_WRONLY);
	return 0;
}
