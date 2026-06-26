## 👋 Welcome to super-productivity 🚀  

super-productivity README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update super-productivity
```
  
## Install and run container
  
```shell
dockerHome="/var/lib/srv/$USER/docker/casjaysdevdocker/super-productivity/latest/volumes"
mkdir -p "$dockerHome"
git clone "https://github.com/dockermgr/super-productivity" "$HOME/.local/share/CasjaysDev/dockermgr/super-productivity"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/super-productivity/volumes/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-super-productivity-latest \
--hostname super-productivity \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/super-productivity:latest
```
  
## via docker-compose  
  
```yaml
services:
  ProjectName:
    image: casjaysdevdocker/super-productivity
    container_name: casjaysdevdocker-super-productivity
    environment:
      - TZ=America/New_York
      - HOSTNAME=super-productivity
    volumes:
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/super-productivity/latest/volumes/data:/data:z"
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/super-productivity/latest/volumes/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/super-productivity
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/super-productivity" "$HOME/Projects/github/casjaysdevdocker/super-productivity"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/super-productivity"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  

