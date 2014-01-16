#include <iostream>
using namespace std;

int main()
{
	struct account {
		int value;
		int obligation;
	} account1, account2, account3, account4;
	
	account1.value = 20000; account1.obligation = 0; account2.value = account1.value;
	account3.value = 20000; account3.obligation = 0; account4.value = account1.value;
	
	int exchange; cout << "Enter the value to exchange:"; cin >> exchange;
	
	if (account1.value + account1.obligation - exchange > 0 
		&& account3.value + account3.obligation + exchange > 0)
	{
		account1.obligation -= exchange;
		account3.obligation += exchange;
	}
	//else { cout << "Inadequate value"; }
	
	account2.value += account1.obligation;
	account4.value += account3.obligation;
	
	//cout << "Account 2 contains $" << account2.value;
	//cout << "Account 4 contains $" << account4.value;
}
