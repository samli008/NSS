# create ctdb samba resource
pcs resource create ctdb ocf:heartbeat:CTDB \
ctdb_recovery_lock="/data/ctdb/ctdb.lock" \
ctdb_dbdir=/var/ctdb ctdb_socket=/tmp/ctdb.socket \
ctdb_logfile=/var/log/ctdb.log \
op monitor interval=10 timeout=30 op start timeout=90 \
op stop timeout=100 --clone

pcs resource create samba systemd:smb --clone
pcs constraint order fs-clone then ctdb-clone
pcs constraint order ctdb-clone then samba-clone
pcs constraint colocation add ctdb-clone with fs-clone
pcs constraint colocation add samba-clone with ctdb-clone
