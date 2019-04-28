FROM postgres:10 AS orig

FROM scratch AS postgres
COPY --from=orig / /

ENV PG_MAJOR=10

RUN export POSTGIS_VERSION=2.4.4+dfsg-4.pgdg90+1 && \
    export POSTGIS_MAJOR=2.4 && \
    apt-get update && \
    apt-get install -f -y --no-install-recommends \
    postgresql-${PG_MAJOR}-repmgr=4.2.0-2.pgdg90+1 \
    postgresql-${PG_MAJOR}-pgaudit=1.3.0-2.pgdg90+1 \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=$POSTGIS_VERSION \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts=$POSTGIS_VERSION \
    postgresql-server-dev-${PG_MAJOR} \
    gcc \
    python-dev \
    openssh-server \
    openssh-client \
    rsync \
    supervisor \
    build-essential \
    wget \
    python-pip && \
    apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -U 'pip>=18.0,<19.0' 'setuptools>=40.0.0,<41'  # packaged version of pip has no --no-cache-dir

RUN pip install --no-cache-dir 'shinto-cli>=0.5.0,<1' 'pgxnclient>=1.2.1,<1.3' 'dumb-init>=1.2.2,<1.3' 'supervisor-stdout>=0.1.1,<0.2'
RUN /usr/local/bin/pgxn install pg_qualstats

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
