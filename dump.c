#include <stdlib.h>
#include <stdio.h>
#include <math.h>

extern int32_t cordic(int32_t);

int main(int argc, char** argv) {

	int32_t scaled_angle;
	int32_t cor_sin;
	register int a1 asm("a1");

	for (scaled_angle=-128160;scaled_angle<=128160;scaled_angle++) {
	    cor_sin = cordic(scaled_angle);
	    printf("%d,%d,%d\n", scaled_angle, cor_sin, a1);
	}

	return 0;
}
