#!/bin/bash
sleep 30
cd /app && \
git add . && \
git commit -m "chore: autocommit from docker" && \
git push
