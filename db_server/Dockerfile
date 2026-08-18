FROM alpine:3.19

RUN apk add --no-cache bash sqlite openssh-client openssh-server openssl coreutils cron

RUN ssh-keygen -A && echo 'root:rootpass' | chpasswd

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
COPY backup.sh /app/backup.sh

RUN chmod +x /app/entrypoint.sh /app/backup.sh

EXPOSE 22 3306

ENTRYPOINT ["/app/entrypoint.sh"]
