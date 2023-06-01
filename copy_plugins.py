import os
import subprocess

def get_value_env(key: str, type_value):
    value = os.getenv(key)
    if value is None:
        print(f"Value is not set, key - {key}")
        exit(1)
    if value == "None":
        return None
    if type_value == str:
        return value
    if type_value == int:
        if not value.isdigit():
            print(f"Isn't int key - {key}, value - {value}")
            exit(1)
        return int(value)
    if type_value == list:
        if value.find(",") == -1:
            print(f"Comma not found in key - {key}. Value - {value}")
            exit(1)
        return value.split(",")
    if type_value == "regex_list":
        if value.find(",.") == -1:
            print(f"Comma and dot not found in key - {key}. Value - {value}")
            exit(1)
        return value.split(",.")
    if type_value == "regex_dict":
        if value.find(",.") == -1:
            print(f"Comma and dot not found in key - {key}. Value - {value}")
            exit(1)
        if value.find(":.") == -1:
            print(f"Colon and dot not found in key - {key}. Value - {value}")
            exit(1)
        lists = value.split(",.")
        result = {}
        for i in lists:
            v = i.split(":.")
            result.update({v[0]: v[1]})
        return result
    exit(1)


def copy_plugins(PLUGINS_LIST: list):
  for plugin in PLUGINS_LIST:
    subprocess.run(f"/usr/bin/rclone copy {os.getenv('S3_BUCKET')}:{os.getenv('S3_BUCKET')}/plugins/{plugin}.jar /app/plugins/".split())
    print(f"Plugin: {plugin} copied successfully")


def main():
  PLUGINS_LIST = get_value_env("PLUGINS_LIST", list)
  copy_plugins(PLUGINS_LIST)
  print("All plugins have been successfully copied")


if __name__ == "__main__":
  main()
