# nfs-HA based ceph rbd with pcs

read -p "pls input nfs vip [192.168.20.174]: " vip
pcs property set stonith-enabled=false

pcs resource create rbd1 ocf:ceph:rbd.in user="admin" pool="rbd" name="disk1" cephconf="/etc/ceph/ceph.conf" --group nfsgroup

pcs resource create FsXFS Filesystem device="/dev/rbd/rbd/disk1" directory="/nssdata" fstype="xfs" options="discard,rw,noatime,allocsize=1g,nobarrier,inode64,logbsize=262144,wsync" op monitor interval=40s on-fail=fence OCF_CHECK_LEVEL=20 --group nfsgroup

pcs resource create NFSDaemon nfsserver nfs_shared_infodir=/nssdata/nfsinfo nfsd_args=" 256 " nfs_no_notify=true op monitor timeout=60s interval=30s --group nfsgroup

pcs resource create NFSExport exportfs clientspec="*" options="rw,sync,no_root_squash,no_subtree_check,insecure" directory="/nssdata" fsid="55" --group nfsgroup

pcs resource create vip IPaddr2 ip=$vip cidr_netmask=24 op monitor interval=20s OCF_CHECK_LEVEL=10 on-fail=fence --group nfsgroup

pcs resource create NFSnotify nfsnotify source_host=$vip --group nfsgroup
