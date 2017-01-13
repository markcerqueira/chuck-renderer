### chuck-renderer

[![Docker Automated build](https://img.shields.io/docker/automated/markcerqueira/chuck-renderer.svg?maxAge=2592000?style=plastic)](https://hub.docker.com/r/markcerqueira/chuck-renderer/)

Docker image for ChucK rendering as a service with .wav to .m4a conversion with FFMPEG.

#### Build

1. Install Docker: `brew cask install docker`
1. Launch Docker.app from the Applications folder to complete installation
1. Clone this repository: `git clone git@github.com:markcerqueira/chuck-renderer.git`
1. Go into the directory: `cd chuck-renderer`
1. Build the image: `. ./compile.sh`
1. Any time you make changes you can stop the old image and rebuild the new one by running: `. ./compile.sh`

`ID` is now set to the container id of the image and `docker ps` will show the chuck-renderer running:

	~ echo $ID
	0b40c14f68de4770c752da68b1092d09390a04eaf252965bcffa31eb51ae4220
	~ docker ps
	CONTAINER ID        IMAGE               COMMAND                   PORTS 
	0b40c14f68de        chuck-renderer      "thin -R config.ru -p"    0.0.0.0:9000->9000/tcp

How to do stuff: 

* The local server in `server/app.rb` can be accessed with a browser by visiting `0.0.0.0:9000/`.
* Accessing `0.0.0.0:9000/debug` displays the debug console.
* The image can be stopped with `docker stop $ID`. `docker ps` will list container ids if `$ID` is incorrect for some reason.
* Logs can be access with `docker logs $ID`.
* To get shell access to the running image: `sudo docker exec -i -t $ID /bin/bash`. Type `exit` in this shell to exit.

#### Resources

* Sinatra stub and Dockerfile setup adapted from [sinatra-mock][1]
* FFMPEG compilation with [AAC encoder][3]

[1]: https://github.com/thoom/sinatra-mock
[2]: https://blog.docker.com/2013/11/introducing-trusted-builds/
[3]: https://trac.ffmpeg.org/wiki/CompilationGuide/Quick/libfdk-aac