#!/bin/bash
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ ! -f /root/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N ""
fi

sqlite3 /app/app_db.sqlite "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT);"
sqlite3 /app/app_db.sqlite "INSERT OR IGNORE INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');"

/usr/sbin/sshd

# schedule a backup every minute for demo use
printf '* * * * * /app/backup.sh >> /var/log/cron.log 2>&1\n' > /etc/crontabs/root
crond -f -l 2
