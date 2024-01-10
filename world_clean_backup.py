import os
import subprocess


def main():
    print("Starting delete olds backup.")
    worlds = os.getenv("WORLDS")
    backuped_total = int(os.getenv("BACKUP_WORLDS_TOTAL"))
    if str(worlds) == "None":
        print("World set is None. Skiping restore worlds.")
        exit()
    cmd = f"/usr/bin/rclone ls {os.getenv('S3_BUCKET')}:{os.getenv('S3_BUCKET')}/backup/{worlds}"
    backuped = subprocess.run(cmd.split(), stdout=subprocess.PIPE, encoding='utf-8').stdout.split("\n")
    backuped_fix = []
    for backup in backuped:
      for string in backup.split():
        if ".tar.bz2" in string:
          backuped_fix.append(string)
    backuped_fix.reverse()
    cnt = 0
    for backup in backuped_fix:
      cnt += 1
      if cnt > backuped_total:
        cmd = f"/usr/bin/rclone delete {os.getenv('S3_BUCKET')}:{os.getenv('S3_BUCKET')}/backup/{worlds}/{backup}"
        backuped = subprocess.run(cmd.split(), stdout=subprocess.PIPE, encoding='utf-8')

main()
