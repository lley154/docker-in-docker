# Docker in Docker
Create a docker image that can run docker images

### Setup
Install docker desktop https://docs.docker.com/desktop/ 

Open a terminal window and execute the following commands
```
$ git clone
$ cd docker-in-docker
$ docker build -t ubuntu-dind -f Dockerfile .
$ docker run --privileged -d --name ubuntu-docker ubuntu-dind
```

### Running the container
The container should be running, so now log into it and run the following commands
```
$ docker exec -it ubuntu-docker bash
# apt update
# apt install sudo
# apt install nano    
# usermod -aG sudo ubuntu    
# usermod -aG docker ubuntu
# passwd ubuntu
# su - ubuntu
```


