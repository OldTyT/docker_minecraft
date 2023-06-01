#!/bin/bash
cd /app && /bin/tar -cvjSf /tmp/"$WORLDS".tar.bz2 *orld* && /usr/bin/rclone copy /tmp/"$WORLDS".tar.bz2 "$S3_BUCKET":"$S3_BUCKET"/worlds && /bin/rm /tmp/"$WORLDS".tar.bz2
