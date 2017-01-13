### chuck-renderer

[![Docker Automated build](https://img.shields.io/docker/automated/markcerqueira/chuck-renderer.svg?maxAge=2592000?style=plastic)](https://hub.docker.com/r/markcerqueira/chuck-renderer/)

Docker image for ChucK rendering as a service with .wav to .m4a conversion with FFMPEG. Check out a demo running on [DigitalOcean](http://chuck-renderer.4860ca31.svc.dockerapp.io:9000/debug).

#### Build

Set up Docker (`brew cask install docker` and then launch Docker.app from the Applications folder to finish installation) if you don't have it yet. Clone this repository, cd into it, and build it:

	docker build -t chuck-renderer .

#### Run
	# Map port 9000 of host to port 9000 of the image and run the image detached
	ID=$(docker run -p 9000:9000 -d chuck-renderer)

`ID` is now set to the container id of the image and `docker ps` will show the chuck-renderer running:

	~ echo $ID
	0b40c14f68de4770c752da68b1092d09390a04eaf252965bcffa31eb51ae4220
	~ docker ps
	CONTAINER ID        IMAGE               COMMAND                   PORTS 
	0b40c14f68de        chuck-renderer      "thin -R config.ru -p"    0.0.0.0:9000->9000/tcp

How to do stuff: 

* Locally, the server in `server/app.rb` can be accessed with a browser by visiting `0.0.0.0:9000/`.
* Accessing `0.0.0.0:9000/debug` displays the debug console.
* The image can be stopped with `docker stop $ID`.
* Logs can be access with `docker logs $ID`.
* To get shell access to the running image: `sudo docker exec -i -t $ID /bin/bash`. Type `exit` in this shell to exit.

#### Resources

* Sinatra stub and Dockerfile setup adapted from [sinatra-mock][1]

[1]: https://github.com/thoom/sinatra-mock
[2]: https://blog.docker.com/2013/11/introducing-trusted-builds/
