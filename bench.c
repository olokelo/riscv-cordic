// Quick and dirty benchmark program
// It might be ineffecient for the math library
// but I've no idea how to do it better

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

extern int32_t cordic(int32_t);

int main(int argc, char** argv) {

    struct timespec start, end;
	int32_t scaled_angle;
	int32_t cor_sin;
	register int32_t a1 asm("a1");
	float refsin;
	float refcos;
	float angle;
	int iters = 0;

    clock_gettime(CLOCK_REALTIME, &start);
    for (scaled_angle=-128160;scaled_angle<=128160;scaled_angle++) {
        cor_sin = cordic(scaled_angle);
        iters++;
    }
    clock_gettime(CLOCK_REALTIME, &end);
    
    printf("Cordic asm took: %f ms\n", (float)(end.tv_nsec-start.tv_nsec) / 1.0e6);
    printf("For: %d iterations\n", iters);
    iters=0;
	
	clock_gettime(CLOCK_REALTIME, &start);
    for (angle=-360.0;angle<=360.0;angle+=0.0028) {
        refsin = sin(0.0174532925*angle);
	    refcos = cos(0.0174532925*angle);
	    iters++;
    }
    clock_gettime(CLOCK_REALTIME, &end);
    
    printf("C math library took: %f ms\n", (float)(end.tv_nsec-start.tv_nsec) / 1.0e6);
    printf("For: %d iterations\n", iters);

	return 0;
}
