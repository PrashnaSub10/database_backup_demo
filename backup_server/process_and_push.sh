#!/bin/bash
set -e

mkdir -p /incoming /repo /repo/backups

FILES=$(ls /incoming/*.enc 2>/dev/null || true)
if [ -z "$FILES" ]; then
  exit 0
fi

cd /repo

if [ ! -d .git ]; then
  git init -b main
  git config user.name "${GIT_USER_NAME:-Backup Bot}"
  git config user.email "${GIT_USER_EMAIL:-backup-bot@example.com}"
fi

if [ -n "${GITHUB_REPO_URL:-}" ]; then
  if ! git remote get-url origin > /dev/null 2>&1; then
    git remote add origin "$GITHUB_REPO_URL"
  else
    git remote set-url origin "$GITHUB_REPO_URL"
  fi
fi

for FILE in $FILES; do
  FILENAME=$(basename "$FILE" .enc)
  DECRYPTED_PATH="/repo/backups/$FILENAME"
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$FILE" -out "$DECRYPTED_PATH" -k "$BACKUP_PASSPHRASE"

  git add "backups/$FILENAME"
  if git diff --cached --quiet; then
    rm -f "$FILE"
    continue
  fi

  git commit -m "Automated backup: $FILENAME" || true

  if [ -n "${GITHUB_REPO_URL:-}" ]; then
    git pull --rebase origin main || true
    git push origin main || true
  fi

  rm -f "$FILE"
done
