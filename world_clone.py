import os
import subprocess

def main():
    print("Starting restored worlds.")
    worlds = os.getenv("WORLDS")
    if str(worlds) == "None":
        print("World set is None. Skiping restore worlds.")
        exit()
    subprocess.run(f"/usr/bin/rclone copy {os.getenv('S3_BUCKET')}:{os.getenv('S3_BUCKET')}/worlds/{worlds}.tar.bz2 /tmp/".split())
    subprocess.run(f"tar -xf /tmp/{worlds}.tar.bz2 -C /app".split())
    subprocess.run(f"rm /tmp/{worlds}.tar.bz2".split())
    print("Worlds successfully restored.")

main()
