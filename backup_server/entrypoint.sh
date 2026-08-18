#!/bin/bash
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

printf '* * * * * root /app/process_and_push.sh >> /var/log/cron.log 2>&1\n' > /etc/cron.d/process
chmod 0644 /etc/cron.d/process
touch /var/log/cron.log
crond -n &

exec /usr/sbin/sshd -D
