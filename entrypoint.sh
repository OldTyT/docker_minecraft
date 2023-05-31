#!/bin/sh

chmod +x /git_* && \
mkdir -p ~/.ssh && \
echo "$SSH_KEY_PRIVATE" > ~/.ssh/id_rsa && \
chmod 600 /root/.ssh/id_rsa && \
echo "$SSH_KEY_PUBLIC" > ~/.ssh/id_rsa.pub && \
echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config && \
git clone $GIT_REPO /app && \
mkdir -p /root/.config/rclone && \
python3 /rclone_conf_generate.py > /root/.config/rclone/rclone.conf && \
rclone copy ${S3_BUCKET}:${S3_BUCKET}/kernels/${KERNEL}.jar /app/ && echo "Kernel $KERNEL copied" && \
test -d /app/plugins || mkdir -p /app/plugins && \
python3 /copy_plugins.py && \
python3 /task_manager.py
