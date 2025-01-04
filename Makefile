CONTAINER_IDS := $(shell docker ps -qa)
IMAGE_IDS := $(shell docker images -qa)
DOCKER_VOLUMES := $(shell docker volume ls -q)
NGINX = ./srcs/requirements/nginx/
DOCKER_COMPOSE = ./srcs/docker-compose.yml
DATA_DIR := srcs/$(shell cat srcs/.env | cut -d'=' -f2)


all:
	mkdir -p $(DATA_DIR)/database $(DATA_DIR)/web $(DATA_DIR)/variables
	cd srcs && docker-compose up --build

test:
	echo $(DATA_DIR)

stop:
	docker-compose -f $(DOCKER_COMPOSE) down

nginx:
	docker build -t nginximg $(NGINX)
	docker run --name nginx -d -p 443:443 nginximg

clean:
# docker stop $(CONTAINER_IDS)
	docker builder prune -f && docker system prune -af
	docker volume rm $(DOCKER_VOLUMES)

reset: clean
	rm -rf $(DATA_DIR)/database $(DATA_DIR)/web