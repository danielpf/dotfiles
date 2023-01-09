#!/bin/sh

truncated_left=$(ip -4 addr show dev eth0 | sed -n -E 's/ *inet *//gp')
my_ip_with_subnet=$(echo $truncated_left | sed -n -E 's/ +.*//gp')
echo $my_ip_with_subnet
