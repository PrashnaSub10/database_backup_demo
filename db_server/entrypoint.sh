#!/bin/bash
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ ! -f /root/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N ""
fi

sqlite3 /app/app_db.sqlite "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT);"
sqlite3 /app/app_db.sqlite "INSERT OR IGNORE INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');"

printf '* * * * * root /app/backup.sh >> /var/log/cron.log 2>&1\n' > /etc/cron.d/backup
chmod 0644 /etc/cron.d/backup
touch /var/log/cron.log
crond -n &

exec /usr/sbin/sshd -D
