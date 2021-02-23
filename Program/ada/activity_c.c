#include <stdio.h>
#include <math.h>

double unif (int *x, int *y, int *z) {
    double tmp;

    *x = 171 * (*x % 177) - 2 * (*x / 177);
    if (*x < 0) {
        *x = *x + 30269;
    }

    *y = 172 * (*y % 176) - 35 * (*y / 176);
    if (*y < 0) {
        *y = *y + 30307;
    }

    *z = 170 * (*z % 178) - 63 * (*z / 178);
    if (*z < 0) {
        *z = *z + 30323;
    }

    tmp = *x / 30269.0 + *y / 30307.0 + *z / 30323.0;

    return tmp - floor(tmp);
}

int main (void) {
    int x, y, z;
    int i;

    x = 5;
    y = 10000;
    z = 3000;

    for (i = 1; i <= 1000; i = i + 1) {
        printf("%.21f\n", unif(&x, &y, &z));
    }

    return 0;
}