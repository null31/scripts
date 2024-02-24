#!/bin/bash

# phone = country code + area code + phone number
PHONE=+550012345678
#PHONE=+$2

# address of your router with LTE modem
# you should create a new user on the router and import a ssh-pubkey
# this new user only need the following permissions on RouterOS: ssh and test
ssh -i /path/to/ssh-privkey user@10.0.0.0 "/tool sms send lte1 phone-number=$PHONE message=\"$1\""
