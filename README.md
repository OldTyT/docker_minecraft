## Docker Minecraft base image

### The principle of operation

After the container is launched, the repository is cloned (in which the minecraft server configuration should be located), then the kernel and plugins are loaded from the remote storage. During operation, autocommits occur (for more information, see this [directory](https://github.com/OldTyT/docker_minecraft/tree/master/crontabs))

## ENV variables


| Variable | Default value |
| ----------- | ----------- |
| XMS    | `512M`   |
| XMX   | `2G`   |
| S3_PROVIDER    | `Other`   |
| S3_REGION    | `ru-central1`   |
| S3_ENDPOINT    | `storage.yandexcloud.net`   |
| PLUGINS_LIST    | `[pluginone,plugintwo]`   |
| SSH_KEY_PRIVATE    | `SSH_KEY_PRIVATE`   |
| SSH_KEY_PUBLIC    | `SSH_KEY_PUBLIC`   |
| GIT_REPO    | `GIT_REPO`   |
| KERNEL    | `KERNEL`   |
| S3_BUCKET    | `S3_BUCKET`   |
| S3_ACCESS_KEY    | `S3_ACCESS_KEY`   |
| S3_ACCESS_KEY_ID    | `S3_ACCESS_KEY_ID`   |

[Example](https://github.com/OldTyT/docker_minecraft/tree/master/docker-compose.yml)
