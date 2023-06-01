#!/bin/bash -l
echo "Start worlds upload."
cd /app && tar -cvjSf "/tmp/${WORLDS}.tar.bz2" *orld*
rclone copy "/tmp/${WORLDS}.tar.bz2" "${S3_BUCKET}:${S3_BUCKET}/worlds" -v || echo "Error when copy worlds."
rm "/tmp/${WORLDS}.tar.bz2"
echo "Ends worlds upload."