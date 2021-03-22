identification division.
program-id. StudentLoan.

environment division.

data division.
working-storage section.
01 loanP     pic 99999V99.
01 iRate     pic 999V99.
01 rate      pic 9V999999.
01 term      pic 999.
01 tRate     pic 9.
01 monthlyP  pic 9999V999999.
01 monPayout pic $$$9.99.

procedure division.
    display "Principle amount of the loan: ".
    accept loanP.
    display "Interest Rate (1-100%):  ".
    accept iRate.
    display "Loan term (months):  ".
    accept term.
    display "(1) fixed or (2) floating interest rate:  ".
    accept tRate.

    if tRate is = 1
        compute rate = ((iRate + 5) / 100.0) / 12.0
    else 
        if tRate is = 2
            compute rate = ((iRate + 2.5) / 100.0) / 12.0
        end-if
    end-if.
display rate.
    compute monthlyP = (rate / (1.0-(1+rate)**(-term))) * loanP.

    move monthlyP to monPayout.
    display "The monthly payment is  " monPayout.
stop run.
