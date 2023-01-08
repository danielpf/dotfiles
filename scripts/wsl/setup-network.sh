#!/bin/sh

truncated_left=$(ip -4 addr show dev eth0 | sed -n -E 's/ *inet *//gp')
my_ip_and_subnet=$(echo $truncated_left | sed -n -E 's/ +.*//gp')
echo "my ip with subnet: $my_ip_and_subnet"

my_ip=$(echo $my_ip_and_subnet | sed -n -E 's/\/.*//gp')
echo "my ip: $my_ip"

my_network_size=$(echo $my_ip_and_subnet | sed -n -E 's/.*\///gp')

if [ $my_network_size == "20" ]; then
  network_mask="255.255.240.0"
else
  echo "network size unknown. update me"
fi
IFS=. read -r i1 i2 i3 i4 <<< "$my_ip"
IFS=. read -r m1 m2 m3 m4 <<< "$network_mask"
network_address=$(printf "%d.%d.%d.%d\n" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))")
echo "network address: $network_address"

other_vm_ip="$(echo $network_address | sed -n -E 's/\.[0-9]+$//gp').50"
echo "other machine ip: "$other_vm_ip

sudo sed -i "s/.*/nameserver ${other_vm_ip}/" /etc/resolv.conf

# alternatives
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo ufw disable
sudo sysctl -p  # you must edit /etc/sysctl.conf
echo "DNS takes a while to come up"
ping google.com
#unbound-control -s 172.30.85.123 local_data $1 A $my_ip

