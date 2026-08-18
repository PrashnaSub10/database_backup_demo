FROM alpine:3.19

RUN apk add --no-cache bash openssh-server openssl git sqlite coreutils cron

RUN ssh-keygen -A && echo 'root:rootpass' | chpasswd

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
COPY process_and_push.sh /app/process_and_push.sh

RUN chmod +x /app/entrypoint.sh /app/process_and_push.sh
RUN mkdir -p /incoming /repo

EXPOSE 22

ENTRYPOINT ["/app/entrypoint.sh"]
