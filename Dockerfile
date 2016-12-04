FROM debian:jessie-backports
ENV DEBIAN_FRONTEND=noninteractive

RUN \
   export DEBIAN_FRONTEND=noninteractive \
   && apt-get -qy update && apt-get -qy dist-upgrade \
   && apt-get -qy install  --no-install-recommends python3 python3-pip libpq5 libpq-dev build-essential libpython3-all-dev git \
   && git clone --depth=1 --branch=master git://git.postgresql.org/git/pgadmin4.git \
   && rm -rf pgadmin4/.git \
   && pip3 install -r pgadmin4/requirements_py3.txt \
   && apt-get -qy purge libpq-dev build-essential libpython3-all-dev git \
   && apt-get -qy --purge autoremove && apt-get -qy clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && rm -rf /usr/share/doc /usr/share/doc-base /usr/share/man /usr/share/locale /usr/share/zoneinfo

EXPOSE 5050

ADD run_pgadmin4.sh /
ENTRYPOINT ["./run_pgadmin4.sh"]
