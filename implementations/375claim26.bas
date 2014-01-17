10 LET ACCOUNT1 = 20000
20 LET ACCOUNT3 = 20000
30 INPUT "Value to exchange for transaction"; EXCHANGE
40 IF ACCOUNT1 - EXCHANGE < 0 THEN PRINT "Inadquate value" : STOP
50 ACCOUNT1 = ACCOUNT1 - EXCHANGE
60 ACCOUNT3 = ACCOUNT3 + EXCHANGE
70 PRINT "Instruction to 1st institution: adjust 2nd account by "; -EXCHANGE

100 REM This does not actually do anything required by the claims;
110 REM it just prints out useful data.
120 PRINT "1st account value: "; ACCOUNT1
130 PRINT "3rd account value: "; ACCOUNT3
