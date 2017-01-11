FROM ubuntu
MAINTAINER Mark Cerqueira <mark.cerqueira@gmail.com>

# ChucK dependencies
RUN apt-get update && apt-get install -y \
	git \
	libsndfile1-dev \
	libpulse-dev \
	libasound2-dev \
	bison \
	flex
	
# RubyGems and sinatra/thin dependencies
RUN apt-get install -y \ 
	rubygems \
	ruby-dev
	
RUN gem install sinatra thin
	
# Clone ChucK, build it, copy it to /bin/
RUN git clone https://github.com/ccrma/chuck.git \
	&& cd chuck/ \
	&& cd src/ \
	&& make linux-pulse \
	&& mv ./chuck /bin/

# Set Sinatra server as work directory
WORKDIR /server
COPY server .

# CMD ["/bin/chuck"]

EXPOSE 9000

CMD ["thin", "-R", "config.ru", "-p", "9000", "start"]
