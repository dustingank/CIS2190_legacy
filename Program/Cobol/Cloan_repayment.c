#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main (void) {
    double loanP, iRate, term, monthlyP;
    int tRate;

    printf("Principal amount of the loan: ");
    scanf("%lf", &loanP);
    printf("Intereset rate (%%): ");
    scanf("%lf", &iRate);
    printf("Loan term(months): ");
    scanf("%lf", &term);
    printf("(1) fixed or (2) floating interest rate: ");
    scanf("%d", &tRate);

    if (tRate == 1) {
        iRate = (iRate + 5.0) / 100.0 / 12.0;
    } else if (tRate == 2) {
        iRate = (iRate + 2.5) / 100.0 / 12.0;
    }

    monthlyP = (iRate / (1.0 - pow(1 + iRate, -term))) * loanP;
    printf("The monthy payment is: %.2f\n", monthlyP);
}