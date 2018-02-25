# bank_accounts
This mod adds an ATM, card swipe, debit and credit cards to Minetest.

# Important
To get an ATM, you must have the give priv.  Type "/giveme bank_accounts:atm".  I designed it this way to prevent buildings from being built out of ATMs.  I want the mod to be realistic, and buildings made out of ATMs are not realistic.

If you have privs priv.  When you grant yourself all, you will be given "seized" priv.  Revoke it, else your account will be seized.

Credits:
 - NathanS21 for textures and models.
 - Tmanyo for code.

This mod uses the currency mod to provide different ways of paying for items in Minetest.
 - Debit card
 - Credit Card

All Items:
 - ATM (Automatic Teller Machine)
 - Card-Swipe
 - ATM Card
 - Debit Card
 - Credit Card

Chatcommands:
 - All players:
  - /set_pin #### (Set your Personal Identification Number)
 - Admins:
  - /account_balance {name} {number} | (Set a player's account balance)
  - /wipe {name} | (Clear a player's bank account)
  - /forgive {name} | (Clear a player's credit debt)
  - /add {name} {number} | (Add to a player's account balance)
  - /subtract {name} {number} | (Subtract from a player's account balance)
  - /seize {name} | (Seize a player's account)
  - /unseize {name} | (Unseize a player's account)

Privileges:
 - bank_teller (Allows players to use a Bank Teller's Computer.  You should only give this to trusted individuals.)
 - unseized (If you have this, your account is not seized.)

With a debit card, when you buy an item through a card-swipe, it automatically takes money that you have deposited out of your account.
With a credit card, when you buy an item through a card-swipe, it builds up credit debt.  There is a recommended monthly credit payment.
If you don't pay the payment, version 1.0 of this mod will not penalize you.  It is more incentive to pay off your credit debt.  Admins 
can look at your credit debt and determine what they want to do.  Either way, the person you bought goods from gets their money.  Admins 
can seize your ability to buy items with credit.

To view your account statistics, you can find an ATM or Automatic Teller Machine.  If you don't already have a PIN (Personal Identification
Number), you can get one by using /set_pin ####.  Replace # with a number.  I don't recommend using a number that is important to you because
the admins can see it.  Once you set your PIN, you are given an ATM card which allows you to access your account.  Right click the ATM with
your ATM card and enter your PIN.  You can then see your account balance, total credit debt, and your monthly credit payment.  If you want
to raise your account balance, you can click deposit and place currency in the correct box for each bill.  It will automatically add up
and be added to your balance.  You can't cheat and place other objects in the boxes, that is insured not to happen.  If you want to withdraw
money from your account, click withdraw and enter the amount.  Don't worry you can't recieve a larger amount of money than is in your account.
You can pay credit debt off by clicking the "Pay Monthly Credit Payment" button.  You have an option to pay the monthly amount or more.
You can get a credit and debit card by clicking on each button on the home screen of the ATM.  Just because you may have 20 of each card 
doesn't make a difference.  You are not any more wealthy than you are with just one of each.

When using a card-swipe, the owner is the seller.  The owner must right click the node first and enter a price for the item(s).  Then the 
owner needs to place the item(s) within the top 8 set of boxes and click enter.  The buyer then right clicks the node and removes the item(s) 
from the top 8 boxes and places them in their own inventory and then clicks enter.  If you are trying to use a debit card and it won't let
you see the screen, that means you do not have enough money on your account.  At this point, you can use your credit card, but don't forget
to pay it off.

You can view use of the chatcommands by viewing the chatcommands.lua file.
This mod is under development still, so there may be some issues.
You can reach the mod creator on irc.inchra.net - #RRHMS-DownDeep or Freenode irc - #minetest.

Bank Teller's Computer:
 - This is used by people who have the bank_teller privilege.  It has all the features an ATM does and allows for wiping a player's   account, forgiving credit debt, reseting PINs, and over-viewing player's account statistics.  If you are an admin, you can press E and rightclick this node, to search player names to check if they are seized or not.
