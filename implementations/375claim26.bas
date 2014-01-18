10 LET account1 = 200.00
20 LET account3 = 300.00
30 INPUT "Value to exchange for transaction"; exchange
40 IF account1 < exchange THEN PRINT "Inadequate value" : STOP
50 account1 = account1 - exchange
60 account3 = account3 + exchange
70 PRINT "Instruction to 1st institution: adjust 2nd account by "; -exchange

100 REM this does not actually do anything required by the claims;
110 REM it just prints out useful data.
120 PRINT "1st account value: "; account1
130 PRINT "3rd account value: "; account3
