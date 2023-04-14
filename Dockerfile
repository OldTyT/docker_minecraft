FROM openjdk:18-jdk-buster

ARG XMS=512M
ARG XMX=2G
ARG KERNEL=KERNEL
ENV XMS=$XMS \
    XMX=$XMX \
    KERNEL=$KERNEL

workdir /app

RUN apt-get update && \
    apt-get install -y \
    netcat &&  \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://ci.md-5.net/job/BungeeCord/

ENTRYPOINT test -f $KERNEL || cp /minecraft/kernel/$KERNEL $KERNEL && java -Xms$XMS -Xmx$XMX -jar $KERNEL nogui

HEALTHCHECK --interval=30s --timeout=5s --start-period=300s CMD nc -z 127.0.0.1 25565
