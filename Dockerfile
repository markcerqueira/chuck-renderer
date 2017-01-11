FROM ubuntu
MAINTAINER Mark Cerqueira <mark.cerqueira@gmail.com>

RUN apt-get update && apt-get install -y \
	git \
	libsndfile1-dev \
	libpulse-dev \
	libasound2-dev \
	bison \
	flex

RUN apt list --installed
	
RUN git clone https://github.com/ccrma/chuck.git \
	&& cd chuck/ \
	&& cd src/ \
	&& make linux-pulse \
	&& mv ./chuck /bin/

CMD ["/bin/chuck"]

