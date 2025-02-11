# Docker in Docker
Create a docker image that can run docker images

### Setup
Install and run docker desktop https://docs.docker.com/desktop/ 

Next, open a terminal window and execute the following commands
```
$ git clone https://github.com/lley154/docker-in-docker.git
$ cd docker-in-docker
$ docker build -t ubuntu-dind -f Dockerfile .
$ docker run --privileged -d -p 5984:5984 -p 8080:8080 --name ubuntu-docker -v /sys/fs/cgroup:/sys/fs/cgroup:rw ubuntu-dind
```

### Running the container
The container should be running, so now log into it and run the following commands
```
$ docker exec -it ubuntu-docker bash
# passwd ubuntu
# su - ubuntu
$ sudo systemctl start docker
$ docker run hello-world
```


