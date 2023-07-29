FROM debian:buster

RUN apt-get update
RUN apt-get install -y wget php php-mysql && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
	mv adminer-4.8.1.php index.php && chown -R root:root /var/www/

RUN wget https://github.com/krallin/tini/releases/download/v0.19.0/tini -O /sbin/tini \
    && chmod +x /sbin/tini

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--"]

CMD	["php", "-S", "[::]:8080", "-t", "/var/www"]