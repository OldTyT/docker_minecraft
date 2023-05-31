import os

result = f"""[{os.getenv("S3_BUCKET")}]
type = s3
provider = {os.getenv("S3_PROVIDER")}
region = {os.getenv("S3_REGION")}
endpoint = {os.getenv("S3_ENDPOINT")}
access_key_id = {os.getenv("S3_ACCESS_KEY_ID")}
secret_access_key = {os.getenv("S3_ACCESS_KEY")}
"""
print(result)
