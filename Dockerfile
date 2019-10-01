FROM postgres:11

ENV PG_MAJOR=11
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && apt-get install -y --no-install-recommends google-cloud-sdk && \
    apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN export POSTGIS_VERSION=2.5.2+dfsg-1~exp1.pgdg90+1 && \
    export POSTGIS_MAJOR=2.5 && \
    apt-get update && \
    apt-get install -f -y --no-install-recommends \
    postgresql-${PG_MAJOR}-repmgr=4.4-1.pgdg90+1 \
    postgresql-${PG_MAJOR}-pgaudit=1.3.0-2.pgdg90+1 \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=$POSTGIS_VERSION \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts=$POSTGIS_VERSION \
    postgresql-server-dev-${PG_MAJOR} \
    python-dev \
    python3-dev \
    rsync \
    build-essential \
    python3-pip \
    python-pip && \
    apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && pip install -U setuptools pip

RUN pip install --no-cache-dir 'shinto-cli>=0.5.0,<1' 'pgxnclient>=1.2.1,<1.3' 'dumb-init>=1.2.2,<1.3' 'supervisor-stdout>=0.1.1,<0.2'
RUN /usr/local/bin/pgxn install pg_qualstats
RUN cd /usr/local/bin && curl -Ls https://github.com/wal-g/wal-g/releases/download/v0.2.12/wal-g.linux-amd64.tar.gz | tar xvz
