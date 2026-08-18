# Database Backup Demo

This project demonstrates a two-server backup architecture using Docker Compose.

## Overview

- DB server is exposed to the host for local testing and database access.
- Backup server is isolated inside an internal Docker subnet.
- Database backups are created, encrypted, transferred, decrypted, and pushed to GitHub.

## Network design

- `public_net`: 172.28.0.0/28
- `private_net`: 172.28.0.16/28 (internal only)

## Services

- `db_server`
- `backup_server`

## Run

```bash
cp .env.example .env
nano .env

docker compose up --build -d
```

## Notes

- The DB server is reachable from the host for learning purposes.
- The backup server does not expose its SSH service to the host.
- GitHub push requires a valid token and repository.
