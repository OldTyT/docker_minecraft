import time
import os
import inspect
import subprocess
from threading import Thread


def cron():
  print(f"Thread {inspect.currentframe().f_code.co_name} start")
  subprocess.run("cron -f -L 8".split())


def server_run():
  print(f"Thread {inspect.currentframe().f_code.co_name} start")
  subprocess.run(f"java -Xms{os.getenv('XMS')} -Xmx{os.getenv('XMX')} -jar /app/{os.getenv('KERNEL')}.jar nogui".split())


def syslog_output():
  print(f"Thread {inspect.currentframe().f_code.co_name} start")
  subprocess.run("busybox syslogd -n -O-".split())

def main():
  cron_th = Thread(target=cron, daemon=True)
  server_run_th = Thread(target=server_run, daemon=True)
  syslog_output_th = Thread(target=syslog_output, daemon=True)
  cron_th.start()
  server_run_th.start()
  syslog_output_th.start()
  print("All thread successfull started.")
  while True:
    if not(cron_th.is_alive() and server_run_th.is_alive() and syslog_output):
      print(f"Thread cron is alive: {cron_th.is_alive()}")
      print(f"Thread server_run is alive: {server_run_th.is_alive()}")
      print(f"Thread syslog_output is alive: {syslog_output_th.is_alive()}")
      exit(1)
    time.sleep(5)


if __name__ == "__main__":
  main()
