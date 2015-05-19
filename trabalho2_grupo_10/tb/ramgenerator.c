#include <stdlib.h>
#include <stdio.h>

int main(){
	int n = 262143;
	n -= 36;
	for(int i = 0; i <= n; i++){
		for(int j = 0; j < 4; j++){
			printf("%x",0);
		}
		printf("\n");
	}
	return 0;
}
