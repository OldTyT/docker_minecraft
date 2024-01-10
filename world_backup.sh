#!/bin/bash -l
if [ "${WORLDS}" = "None" ]
then
  echo "Env WORLDS value is None. Skiping world clone."
fi
if [ "${WORLDS}" != "None" ]
then
  echo "Start worlds upload."
  BACKUP_FILE="/tmp/${WORLDS}_$(date +%s).tar.bz2"
  cd /app && tar -cjSf "${BACKUP_FILE}" *orld*
  rclone copy "${BACKUP_FILE}" "${S3_BUCKET}:${S3_BUCKET}/backup/${WORLDS}" || echo "Error when copy worlds."
  rm "${BACKUP_FILE}"
  echo "Ends worlds upload."
  python3 /world_clean_backup.py
fi
