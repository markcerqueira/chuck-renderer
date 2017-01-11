### chuck-renderer
Docker image for chuck

#### Build
	docker build -t chuck-renderer .

#### Run
	# Map port 9000 to port 9000 if the Docker image and run the image detached
	ID=$(docker run -p 9000:9000 -d chuck-renderer)

`ID` is now set to the container id of the image and `docker ps` will show the chuck-renderer running:

	~ echo $ID
	0b40c14f68de4770c752da68b1092d09390a04eaf252965bcffa31eb51ae4220
	~ docker ps
	CONTAINER ID        IMAGE               COMMAND                   PORTS 
	0b40c14f68de        chuck-renderer      "thin -R config.ru -p"    0.0.0.0:9000->9000/tcp

Locally, the server in `server/app.rb` can be accessed with a browser by visiting `http://0.0.0.0:9000/`. The Docker image can be stopped with `docker stop $ID`.

#### Resources

* Sinatra stub and Dockerfile setup adapted from [sinatra-mock][1]

[1]: https://github.com/thoom/sinatra-mock
