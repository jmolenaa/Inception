CONTAINER_IDS := $(shell docker ps -qa)
IMAGE_IDS := $(shell docker images -qa)
NGINX = ./srcs/requirements/nginx/


nginx:
	docker build -t nginximg $(NGINX)
	docker run --name nginx -d -p 443:443 nginximg

rmnginx:
	docker stop nginx
	docker rm nginx

clean:
	docker stop $(CONTAINER_IDS)
	docker system prune -af