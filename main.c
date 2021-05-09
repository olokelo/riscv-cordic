#include <stdlib.h>
#include <stdio.h>
#include <math.h>

extern int32_t cordic(int32_t);

int main(int argc, char** argv) {

	int32_t scaled_angle;
	float angle = 30.0;    // angle in degrees

	if (argc == 2) {
		scaled_angle = atoi(argv[1]);
		angle = (float)scaled_angle / 256;
		printf("Scaled angle taken from argv = %d\n", scaled_angle);
	} else {
		scaled_angle = angle*256;
	}

	int32_t cor_sin = cordic(scaled_angle); 
	// hack: cordic returns 2 values but plain c can only read one from a0 (sin)
	// the second one has to be retrieved from a1 directly
	register int a1 asm("a1");
	int32_t cor_cos = a1;
	
	printf("Raw values: %d, %d\n", cor_sin, cor_cos);

	float fsin = (float)cor_sin;
	float fcos = (float)cor_cos;
	fsin = fsin/256;
	fcos = fcos/256;

	printf("Real values: %f, %f\n", fsin, fcos);

	// functions from c math library take radians
	float refsin = sin(0.0174532925*angle);
	float refcos = cos(0.0174532925*angle);

	printf("Reference values: %f %f\n", refsin, refcos);

	return 0;
}
