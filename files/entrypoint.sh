#!/bin/bash -e

[ ${DEBUG:-0} -ne 1 ] || set -x

## Overridable parameters

MASTER_HOST=${MASTER_HOST:-127.0.0.1}
MASTER_PORT=${MASTER_PORT:-80}
MASTER_PROTOCOL=${MASTER_PROTOCOL:-http}
MASTER_USER=""
MASTER_PASSWORD=""

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
  password: "${MASTER_PASSWORD}"
  url: ${MASTER_PROTOCOL}://${MASTER_HOST}:${MASTER_PORT}
  user: "${MASTER_USER}"
EOF
    salt-call state.sls --retcode-passthrough jenkins.client
else
    exec "$@"
fi
