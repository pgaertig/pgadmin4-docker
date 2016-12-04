#!/bin/bash
export USER_ID=${DATA_USER_ID:-1000}
export GROUP_ID=${DATA_GROUP_ID:-1000}

#Link configuration volume
mkdir -p /pgadmin-data
ln -s /pgadmin-data /root/.pgadmin
chmod a+x /root

#Create unprivileged user
groupadd -g $GROUP_ID -o pgadmin
useradd --shell /usr/sbin/nologin -u $USER_ID -o -c "" -g $GROUP_ID pgadmin --home /pgadmin-data
chown pgadmin:pgadmin /pgadmin-data

#Create persistent config file on volume
if [ ! -f /pgadmin-data/config_local.py ]; then
  cat /pgadmin4/web/config.py  \
     | sed "s/DEFAULT_SERVER = 'localhost'/DEFAULT_SERVER = '0.0.0.0'/" \
     > /pgadmin-data/config_local.py
  chown pgadmin:pgadmin /pgadmin-data/config_local.py
fi
ln -s /pgadmin-data/config_local.py /pgadmin4/web/config_local.py


#Run unprivileged
chroot --userspec pgadmin:pgadmin / python3 pgadmin4/web/pgAdmin4.py

