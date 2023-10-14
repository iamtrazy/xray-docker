# Instructions

## prerequisites - docker.io and docker-buildx

sudo apt-get update && sudo apt-get install -y docker.io docker-buildx  
sudo usermod -aG docker $USER

## clone this repository to a vps

git clone https://github.com/iamtrazy/xray-docker.git

## edit and change the $UUID in the .env file

eg: nano xray-docker/.env

## build the docker image using docker buildx

cd xray-docker  
docker buildx build -t xray .

## run the docker image with host port 80

docker run --name xray -p 80:80 --restart unless-stopped -d xray:latest
