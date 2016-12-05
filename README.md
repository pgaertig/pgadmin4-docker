# pgadmin4-docker
This is pgAdmin4 Docker container with the following specification:

 - used: Debian Jessie, Python 3.4, master branch of pgAdmin4 https://git.postgresql.org/gitweb/?p=pgadmin4.git 
 - by default it is setup as multi-user server where users' data and configuration is persisted in a volume
 - pgAdmin4 server-side app starts under unprivileged user created withing container;
 - pgAdmin4 configuration can modified at any time (container restart required)

## Volume

The container persists all user data in `/pgadmin-data` which should be mounted as volume. On first run of the container the `config_local.py` file is generated on the volume. That file contains actual pgAdmin4 configuration. Any change to the config file will be effective after container restart. To reset the configuration just remove the file.

## Permissions

Ownership and group of files created within the data volume can be controlled by the following environment variables:

 - DATA_USER_ID - numeric user identifier, default: 1000
 - DATA_GROUP_ID - numeric group identifier, default: 1000

The container runs pgAdmin4 process as an unprivileged user identified with the above variables.

## Local build & run

To build locally run the following

    docker build -t pgadmin4:latest .

Then you can run it like this example:

    docker run -it --rm -v /home/share/pgadmin-data:/pgadmin-data --net=host --entrypoint=/bin/bash pgadmin4:latest

You should be able to see pgAdmin4 in browser once you go to http://localhost:5050 or to the actual host address where the above command was run.

