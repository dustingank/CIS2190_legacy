           >>SOURCE FORMAT FREE
identification division.
program-id. coboltut.
author. Yizhou Wang.
date-written. March 25th 2021.

environment division.

data division.
file section.
working-storage section.
01 userName pic X(30) value "You".
01 num1    pic 9 value zeroes.
01 num2    pic 9 value zeros.
01 total   pic 99 value 0.
01 SSNum.
       02 SSArea   pic 999.
       02 SSGroup  pic 99.
       02 SSSerial pic 9999.

01 PIValue constant as 3.14.

01 sampleData  pic x(10) value "stuff".
01 kustLetters pic AAA value "ABC".
01 justNums    pic 9(4) value 1234.
01 signedInt   pic S9(4) value -1234
01 payCheck    pic 9(4)V99 value ZEROS.
01 Customer.
       02 IdNum    pic 9(3).
       02 custName pic X(20).
       02 dateOfBirth.
           03 month       pic 99.
           03 dateOfBirth pic 99.
           03 year        pic 9(4).

*> ZERO, ZEROS
*> SPACE SPACES
*> HIGH-VALUE / HIGH-VALUES / LOW-VALUE / LOW-VALUES

procedure division.

move "more stuff" to sampleData
move "123" to sampleData
move 123 to sampleData
display sampleData
display payCheck
move "123Bob Smith           12211974" to Customer
display custName
display month "/" dateOfBirth "/" year



display "What is your name " with no advancing
accept userName
display "Hello " userName

move zeros to userName
display userName 
display "Enter 2 values to sum "
accept num1
accept num2
compute total = num1 + num2
display num1 " + " num2 " = " total
display "Enter you social security number: "
accept SSnum.
display "Area " SSArea
display "social security number: " SSnum.

stop run.
