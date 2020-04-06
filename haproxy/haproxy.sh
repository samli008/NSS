read -p "pls input vip[192.168.20.175]: " vip
pcs resource create vip ocf:heartbeat:IPaddr2 ip=$vip cidr_netmask=24 op monitor interval=30s
pcs resource create lb-haproxy systemd:haproxy
pcs constraint colocation add lb-haproxy with vip
pcs constraint order start vip then lb-haproxy
