#!/bin/bash -e

[ ${DEBUG:-0} -ne 1 ] || set -x

## Overridable parameters

MASTER_HOST=${MASTER_HOST:-127.0.0.1}
MASTER_PORT=${MASTER_PORT:-80}
MASTER_PROTOCOL=${MASTER_PROTOCOL:-http}
MASTER_USER="${MASTER_USER:-}"
MASTER_PASSWORD="${MASTER_USER:-}"

## Functions

function log_info() {
    echo "[INFO] $*"
}

## Main

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
#    cat << EOF > /srv/pillar/jenkins/master.sls
#jenkins:
#  client:
#    master:
#      host: ${MASTER_HOST}
#      port: ${MASTER_PORT}
#      proto: ${MASTER_PROTOCOL}
#      username: ${MASTER_USER}
#      password: ${MASTER_PASSWORD}
#EOF

    cat << EOF > /etc/salt/minion.d/jenkins.conf
jenkins:
  url: ${MASTER_PROTOCOL}://${MASTER_HOST}:${MASTER_PORT}
EOF

    if [[ -n "$MASTER_USER" ]]; then
        echo "user: ${MASTER_USER}" >> /etc/salt/minion.d/jenkins.conf
        echo "password: ${MASTER_PASSWORD}" >> /etc/salt/minion.d/jenkins.conf
    fi

    salt-call state.sls --retcode-passthrough jenkins.client
else
    exec "$@"
fi
