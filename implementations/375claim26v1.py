account1 = {'value': 20000, 'obligation': 0} ; account2 = {'value': account1['value']}
account3 = {'value': 20000, 'obligation': 0} ; account4 = {'value': account3['value']}

exchange = input('Enter the value to exchange: ')

if ((account1['value'] + account1['obligation'] - exchange) > 0 and
	(account3['value'] + account3['obligation'] + exchange) > 0):
	account1['obligation'] -= exchange
	account3['obligation'] += exchange
#else:
#	print "Inadequate value"

account2['value'] += account1['obligation']
account4['value'] += account3['obligation']

#print "Account 2 adjusted to contain $", account2['value']
#print "Account 4 adjusted to contain $", account4['value']



