apt update && apt full-upgrade -y
apt install -y gvm gvm-tools
gvm-setup
gvm-check-setup
gvm-start


## postgress

service postgresql start
#check
pg_lsclusters

# if it does not work
pg_ctlcluster 16 main start

# Redis start
service redis-server start

# Postgress service status
service postgresql status
service redis-server status

service postgresql start


# GVmd version check


gvmd --version



└─# ospd-openvas --version
OSP Server for openvas: 22.10.6
OSP: 22.10.6
OSPd OpenVAS: 22.10.6

Copyright (C) 2014-2021 Greenbone AG
License GPLv2+: GNU GPL version 2 or later
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
