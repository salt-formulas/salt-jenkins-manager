FROM debian:stretch

MAINTAINER Filip Pytloun <filip@pytloun.cz>

ARG version=2017.7
ENV VERSION $version

ENV DEBIAN_FRONTEND noninteractive

# Install saltstack and required packages
RUN apt-get -qq update && \
    apt-get install -y git wget gnupg2 python-jenkins python-bcrypt python-requests && \
    wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
    echo "deb http://repo.saltstack.com/apt/debian/9/amd64/${VERSION} stretch main" >/etc/apt/sources.list.d/saltstack.list && \
    apt-get update && apt-get install -y salt-minion pwgen && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install jenkins formula
RUN git clone https://github.com/salt-formulas/salt-formula-jenkins.git && \
    mkdir -p /srv/salt/jenkins && mv salt-formula-jenkins/jenkins/* /srv/salt/jenkins/ && \
    mv salt-formula-jenkins/_grains /srv/salt/ && \
    mv salt-formula-jenkins/_modules /srv/salt/ && \
    mv salt-formula-jenkins/_states /srv/salt/ && \
    mkdir -p /var/cache/salt/minion/jenkins/source /var/cache/salt/minion/jenkins/jobs && \
    rm -rf salt-formula-jenkins

# Use tini as subreaper in Docker container to adopt zombie processes
ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd
RUN wget https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -O /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

# Required files
COPY files/minion.conf /etc/salt/minion.d/minion.conf
COPY files/top.sls /srv/salt/top.sls
COPY files/entrypoint.sh /entrypoint.sh

COPY files/pillar /srv/pillar

# Configure salt
RUN useradd --system salt && \
    chown -R salt:salt /etc/salt /var/cache/salt /var/log/salt /etc/salt /srv/salt

USER salt
RUN salt-call saltutil.sync_all

ENTRYPOINT ["/bin/tini", "--", "/entrypoint.sh"]
