#!/bin/sh

chmod +x /git_* && \
mkdir -p ~/.ssh && \
echo "$SSH_KEY_PRIVATE" > ~/.ssh/id_rsa && \
chmod 600 /root/.ssh/id_rsa && \
echo "$SSH_KEY_PUBLIC" > ~/.ssh/id_rsa.pub && \
echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config && \
git clone $GIT_REPO /app && \
cd /app && \
# find /app/plugins -type f -exec python3 /config_fix.py {} \; && \
mkdir -p /root/.config/rclone && \
python3 /rclone_conf_generate.py > /root/.config/rclone/rclone.conf && \
python3 /world_clone.py && \
rclone copy ${S3_BUCKET}:${S3_BUCKET}/kernels/${KERNEL}.jar /app/ && echo "Kernel $KERNEL copied" && \
test -d /app/plugins || mkdir -p /app/plugins && \
python3 /copy_plugins.py && \
env | grep -E "WORLDS|S3_BUCKET" >> /etc/environment && \
python3 /task_manager.py
