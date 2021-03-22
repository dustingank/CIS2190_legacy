identification division.
program-id. TimeValueofMoney.

environment division.

data division.
working-storage section.
01 presentVal    pic 9(8)V99.
01 futureVal     pic 9(8)V99.
01 futurePay     pic 9(8)V99.
01 futureVal_out pic $ZZ,ZZZ,ZZZ.99.
01 diffVal       pic 9(8)V99.
01 diffVal_out   pic $ZZ,ZZZ,ZZZ.99.
01 intRate       pic 999V99.
01 numP          pic 99.

procedure division.

    display "Present value amount ($): ".
    accept presentVal.
    display "Interest rate (0-100%): ".
    accept intRate.
    display "Number of years: ".
    accept numP.

    if intRate < 0 or intRate > 100 then
        display "Interest rate not between 0-100"
        stop run
    end-if.

    compute futureVal = presentVal * ((1 + (intRate / 100.0)) ** numP). 
    move futureVal to futureVal_out.
    
    display "Amount received in " numP " years: ".
    accept futurePay.
    compute diffVal = futureVal - futurePay.
    move diffVal to diffVal_out.

    display futureVal.
    display "The future value of the investment is " futureVal_out.
    display "The difference in value is            " diffVal_out.

stop run.
