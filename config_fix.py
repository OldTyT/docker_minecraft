import sys
import re
import os

file_path = sys.argv[1]

def read_file(file_path: str) -> str:
    file_read = open(file_path, "r")
    content = file_read.read()
    file_read.close()
    return content


def replace_in_text(content: str) -> str:
    content = re.sub(r"MYSQL_HOST", os.getenv("MYSQL_HOST"), content)
    content = re.sub(r"MYSQL_PORT", os.getenv("MYSQL_PORT"), content)
    content = re.sub(r"MYSQL_DB", os.getenv("MYSQL_DB"), content)
    content = re.sub(r"MYSQL_USER", os.getenv("MYSQL_USER"), content)
    content = re.sub(r"MYSQL_PASSWORD", os.getenv("MYSQL_PASSWORD"), content)
    return content


def write_file(content: str, file_path: str) -> bool:
    file_write = open(file_path, "w")
    file_write.write(content)
    file_write.close()
    return True


def main():
    content = read_file(file_path)
    content = replace_in_text(content)
    write_file(content, file_path)

if __name__ == "__main__":
    main()
