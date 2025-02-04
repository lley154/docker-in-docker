# Docker in Docker
Create a docker image that can run docker images

### Setup
Install and run docker desktop https://docs.docker.com/desktop/ 

Next, open a terminal window and execute the following commands
```
$ git clone https://github.com/lley154/docker-in-docker.git
$ cd docker-in-docker
$ docker build -t ubuntu-dind -f Dockerfile .
$ docker run --privileged -d --name ubuntu-docker ubuntu-dind
```

### Running the container
The container should be running, so now log into it and run the following commands
```
$ docker exec -it ubuntu-docker bash
# passwd ubuntu
# su - ubuntu
$ docker run hello-world
```


