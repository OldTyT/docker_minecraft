#!/bin/bash -l

remote_backups_hourly="${REMOTE_BACKUPS_HOURLY:-12}"
remote_backups_daily="${REMOTE_BACKUPS_DAILY:-7}"
remote_backups_weekly="${REMOTE_BACKUPS_WEEKLY:-4}"
remote_backups_monthly="${REMOTE_BACKUPS_MONTHLY:-3}"
current_hours=$(date '+%Y%m%d%H%M%S')

function show_error() {
    local message="${1}"; local funcname="${2}"; log_date=$(date '+%Y/%m/%d:%H:%M:%S')
    echo -e "[ERROR.${funcname} ${log_date}] ${message}" >&2
    glbl_err=1
}

function show_notice() {
    local message="${1}"; local funcname="${2}"; log_date=$(date '+%Y/%m/%d:%H:%M:%S')
    echo -e "[NOTICE.${funcname} ${log_date}] ${message}"
}

function detect_type() {
    test -z "${remote_backups_daily}" || {
        type='daily'
        remote_backups="${remote_backups_daily:-7}"
        inc_type='inc'
        backup_days="${remote_backups}"
    }
    test "$(date +%u)" = "7" && { test -z "${remote_backups_weekly}" || {
        type='weekly'
        inc_type='full'
        remote_backups="${remote_backups_weekly}"
        backup_days=$((remote_backups_weekly*7))
    } }
    test "$(date +%d)" = "01" && { test -z "${remote_backups_monthly}" || {
        type='monthly'
        inc_type='full'
        remote_backups="${remote_backups_monthly}"
        backup_days=$((( $(date -d "${remote_backups_monthly} months" +%s) - $(date +%s)) / (60*60*24)))
    } }
    test "$(date +%H)" != "00" && { test -z "${remote_backups_hourly}" || {
        type='hourly'
        inc_type='full'
        remote_backups="${remote_backups_hourly}"
        backup_days=1
    } }
}

function rclone_sync() {
    local source="${1}"
    local target="${2}"
    local mode="${3:-default}"
    local err=0
    local start_time
    local end_time
    local duration
    local protocol
    local detected_domain
    local upload_domain
    local remote_backup_values
    local remote_files
    local remote_size
    test "${#}" -eq 2 || test "${#}" -eq 3 || { show_error "Wrong usage of the function! Args=${*}" "${FUNCNAME[0]}"; return 1; }
    show_notice "Sync ${source} to ${target}" "${FUNCNAME[0]}"
    start_time=$(date +%s)
    rclone -v "${rclone_sync_opts[@]}" sync "${source}" "${target}" 2>&1 || {
        local rclone_error=$?; local ignore_error=0
        for code in "${rclone_ignore_codes[@]}"; do
            test "${code}" -eq "${rclone_error}" && { ignore_error=1; break; }
        done
        test "${ignore_error}" -eq 0 && show_error "Error on rclone_sync ${source} to ${target} with code ${rclone_error}" "${FUNCNAME[0]}"; err=1
    }
    test "${mode}" != "no_check" && {
        remote_backup_values=$(rclone size "${target}")
        remote_files=$(echo "${remote_backup_values}" | grep 'Total objects:' | awk '{print $3}')
        remote_size=$(echo "${remote_backup_values}" | grep -oP '\(\d+\sByte.*?\)' | grep -oP '\d+')
    }
    return "${err}"
}

function rclone_delete() {
    local err=0; local target="${1}"; local count="${2}"; local rclone_conf="${rclone_alternative_conf:-/root/.config/rclone/rclone.conf}"
    test -f "${rclone_conf}" || { show_error "Can't find rclone configuration file (${rclone_conf}), you need to configure rclone or set alternative path to config by rclone_alternative_conf variable." "${FUNCNAME}"; return 1; }
    test "${#}" -eq 2 || { show_error "Wrong usage of the function! Args=${*}" "${FUNCNAME}"; return 1; }
    rclone -q lsd "${target}"> /dev/null 2>&1 || { show_error "Smth went wrong while listing rclone storages."; local err=1; }
    total=$(rclone -q ls "${target}" | wc -l)
    to_delete=$((total - count))
    test "${to_delete}" -gt 0 && {
        for var in $(rclone -q ls "${target}" | grep -E '20[0-9][0-9][0-1][0-9][0-9][0-9]' | head -n "${to_delete}" | awk '{print $2}'); do
            show_notice "Deleting ${var}" "${FUNCNAME}"
            rclone --config "${rclone_conf}" -v "${rclone_purge_opts[@]}" delete "${target}/${var}" 2>&1 || { show_error "Error on rclone purge ${var}" "${FUNCNAME}"; local err=1; }
        done
    } || show_notice "Nothing to purge." "${FUNCNAME}"
    return "${err}"
}

if [ "${WORLDS}" = "None" ]
then
  echo "Env WORLDS value is None. Skiping world clone."
fi
if [ "${WORLDS}" != "None" ]
then
  detect_type
  echo "Start worlds upload."
  BACKUP_FILE="/tmp/${WORLDS}_${current_hours}.tar.bz2"
  cd /app && tar -cjSf "${BACKUP_FILE}" *orld*
  rclone_sync "${BACKUP_FILE}" "${S3_BUCKET}:${S3_BUCKET}/backup/${type}/${WORLDS}" || echo "Fail upload backup"
  rclone_delete "${S3_BUCKET}:${S3_BUCKET}/backup/${type}/${WORLDS}" "${remote_backups}"
  rm "${BACKUP_FILE}"
  echo "Ends worlds upload."
fi
