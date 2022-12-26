#!/bin/sh

function some_ip() {
    resulting_ip="$(echo $my_ip | sed -n -E 's/\.[0-9]+$//gp').$1"
}

# alternatives
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo ufw disable
#unbound-control -s 172.30.85.123 local_data $1 A $my_ip

my_ip_with_subnet=$(get_ip.sh)
my_ip=$(echo $my_ip_with_subnet | sed -n -E 's/\/.*//gp')

other_vm_ip=$(some_ip 50)
sudo echo "nameserver ${other_vm_ip}" >/etc/resolv.conf
