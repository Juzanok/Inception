FROM debian:buster

RUN apt-get update -y && \
	apt-get install mariadb-server -y && \
	rm -rf /var/lib/apt/lists/*

ARG DB_NAME DB_USER DB_PASSWORD DB_ROOT_PASSWORD

COPY ./tools/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

RUN chown -R mysql:mysql /var/lib

EXPOSE 3306

CMD ["/usr/local/bin/mariadb.sh", "mysqld", "--bind-address=0.0.0.0"]