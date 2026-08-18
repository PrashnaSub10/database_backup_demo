#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/tmp/backups"
mkdir -p "$BACKUP_DIR"

RAW_BACKUP="$BACKUP_DIR/db_${TIMESTAMP}.sqlite"
ENC_BACKUP="$BACKUP_DIR/db_${TIMESTAMP}.sqlite.enc"

sqlite3 /app/app_db.sqlite ".backup '$RAW_BACKUP'"
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$RAW_BACKUP" -out "$ENC_BACKUP" -k "$BACKUP_PASSPHRASE"

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$ENC_BACKUP" root@172.28.0.19:/incoming/

rm -f "$RAW_BACKUP" "$ENC_BACKUP"
