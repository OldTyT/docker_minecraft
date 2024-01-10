FROM openjdk:18-jdk-slim-buster

ENV XMS=512M \
    XMX=2G \
    KERNEL=KERNEL \
    S3_BUCKET=S3_BUCKET \
    S3_ACCESS_KEY=S3_ACCESS_KEY \
    S3_ACCESS_KEY_ID=S3_ACCESS_KEY_ID \
    S3_PROVIDER="Other" \
    S3_REGION="ru-central1" \
    S3_ENDPOINT="storage.yandexcloud.net" \
    PLUGINS_LIST="[pluginone,plugintwo]" \
    SSH_KEY_PRIVATE=SSH_KEY_PRIVATE \
    SSH_KEY_PUBLIC=SSH_KEY_PUBLIC \
    GIT_REPO=GIT_REPO \
    WORLDS="None" \
    MYSQL_HOST="MYSQL_HOST" \
    MYSQL_PORT="3306" \
    MYSQL_DB="MYSQL_DB" \
    MYSQL_USER="MYSQL_USER" \
    MYSQL_PASSWORD="MYSQL_PASSWORD" \
    BACKUP_WORLDS_TOTAL=30

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    netcat \
    cron \
    rclone \
    git \
    busybox \
    python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /

RUN mv /crontabs/* /etc/cron.d/ && \
    chmod 600 /etc/cron.d/*

# https://ci.md-5.net/job/BungeeCord/

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=500s CMD nc -z 127.0.0.1 25565
