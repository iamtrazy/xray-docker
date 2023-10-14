# Instructions

## clone this repository to a vps

git clone https://github.com/iamtrazy/xray-docker.git

## edit and change the $UUID in the config.json file using a text editor

eg: xray-docker/config.json

## build the docker image using docker buildx

cd xray-docker
docker buildx build -t xray .

## run the docker image with host port 80

docker run --name xray -p 80:80 -d xray:latest
