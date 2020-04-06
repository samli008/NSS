# config smb.conf on both nodes

yum -y install samba ctdb cifs-utils

useradd liyang -s /sbin/nologin
(echo "liyang"; echo "liyang") | smbpasswd -s -a liyang

chown -R liyang /data/smb
chmod 775 /data/smb

cat > /etc/samba/smb.conf << EOF
[global]
        workgroup = WORKGROUP
        server string = Samba Server Version %v
        security = user
        username map = /etc/samba/smbusers
#        clustering = yes
#        ctdbd socket = /tmp/ctdb.socket
[samba]
        comment = smb
        path = /data/smb
        valid users = +liyang
        write list = +liyang
EOF

cat > /etc/samba/smbusers << EOF
liyang = admin
EOF

# config ctdb internal ip for ctdb-clone on both nodes
cat << END > /etc/ctdb/nodes
192.168.20.152
192.168.20.147
END

# config ctdb external vip for samba-clone on both nodes
cat << END > /etc/ctdb/public_addresses
192.168.20.201/24 eth0
192.168.20.202/24 eth0
END
