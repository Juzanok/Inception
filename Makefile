GREEN	:= $(shell tput -Txterm setaf 2)
YELLOW	:= $(shell tput -Txterm setaf 3)
RESET	:= $(shell tput -Txterm sgr0)

all: up

up: setup
	@echo "$(GREEN)[ Building containers ... ]$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@echo "$(GREEN)[ Removing containers ... ]$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml down

re: down up

setup:
	@if [ ! -f ./srcs/requirements/nginx/tools/jkarosas.42.fr.key ] || [ ! -f ./srcs/requirements/nginx/tools/jkarosas.42.fr.crt ]; then \
		echo "$(YELLOW)[ Generating SSL certificate ... ]$(RESET)"; \
		openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ./srcs/requirements/nginx/tools/jkarosas.42.fr.key -out ./srcs/requirements/nginx/tools/jkarosas.42.fr.crt -subj "/C=GE/L=Wolfsburg/O=42/OU=student/CN=jkarosas42" > /dev/null 2>&1; \
		echo "$(YELLOW)[ SSL certificate generated ... ]$(RESET)"; \
	fi
	@if [ ! -d /home/jkarosas/data/wordpress ]; then \
		mkdir -p /home/jkarosas/data/wordpress; \
	fi
	@if [ ! -d /home/jkarosas/data/mariadb ]; then \
		mkdir -p /home/jkarosas/data/mariadb; \
	fi

clean:
	@docker stop $$(docker ps -qa);				\
	docker rm $$(docker ps -qa);				\
	docker rmi -f $$(docker images -qa);		\
	docker volume rm $$(docker volume ls -q);	\
	docker network rm $$(docker network ls -q);	\
	2>/dev/null;
	@sudo rm -r /home/jkarosas/data/wordpress/*;
	@sudo rm -r /home/jkarosas/data/mariadb/*;

.PHONY: all up down re setup clean