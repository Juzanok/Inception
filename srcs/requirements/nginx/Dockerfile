FROM debian:buster

RUN apt -y update && \
	apt install -y nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]