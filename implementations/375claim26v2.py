class Account:
	def __init__(self, value, obligation = None):
		self.value = value
		self.obligation = obligation
		
account1 = Account(2000, 0) ; account2 = Account(account1.value)
account3 = Account(2000, 0) ; account4 = Account(account3.value)

exchange = input('Enter the value to exchange: ')

if ((account1.value + account1.obligation - exchange) > 0 and
	(account3.value + account3.obligation + exchange) > 0):
	account1.obligation -= exchange
	account3.obligation += exchange
#else:
#	print "Inadequate value"

account2.value += account1.obligation
account4.value += account3.obligation

#print "Account 2 adjusted to contain $", account2.value
#print "Account 4 adjusted to contain $", account4.value



