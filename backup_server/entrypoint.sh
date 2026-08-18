#!/bin/bash
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

# SSH server start
/usr/sbin/sshd

# schedule processing every minute for demo use
printf '* * * * * /app/process_and_push.sh >> /var/log/cron.log 2>&1\n' > /etc/crontabs/root
crond -f -l 2
