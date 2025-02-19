Docker-compose makes most of these useless, so you might not use these, but if you like to experiment and see stuff happen step by step these commands might help out a bit.

### Glossary

- `image_name` - the name identifying the image, you can us either the ID that is assigned to the image (this is a string of characters, f.e. ff221270b9fb, don't recommend), the first 3 characters of aforementioned ID or the name assigned to the image when you build it. I heavily reccommend naming your images and using the name for the other commands, for Inception f.e. (nginx_img, mariadb_img, wordpress_img)
- `container_name` - the name identifying the container, same things apply as for `image_name`. For Inception f.e. (nginx, mariadb, wordpress)

### Working with images

- `docker images`                                        - List all locally stored images
- `docker build <path to Dockerfile>`                    - Build an image from a Dockerfile, f.e. `docker build ./requirements/nginx/`
- `docker build -t <image_name> <path to Dockerfile>`    - Build an image from a Dockerfile and give it a name

### Working with containers

- `docker ps`[^1]                                                  - List running containers
- `docker ps -a`                                                   - List all containers (running + stopped)
<br>
- `docker run <image_name>`                                        - Run a container using the specified image
- `docker run -d <image_name>`                                     - Run a container in detached mode
- `docker run -d -p <container_port>:<host_port> <image_name>`[^2] - Run a container, mapping the <container_port> to the <host_port>
- `docker run -it <image_name> bash`                               - Run a container interactively with a shell
<br>
- `docker start <container_name>`                                  - Start a stopped container
- `docker stop <container_name>`                                   - Stop a running container
- `docker logs <container_name>`[^3]                               - View container logs
<br>
- `docker cp <source> <container_name>:<destination>`[^4]          - Copies a file from the host machine to the destination in the specified container
- `docker cp <container_name>:<source> <destination>`[^5]          - Copies a file from the container to the destination on the host machine
<br>
- `docker exec -it <container_name> <command>`                     - Execute the command in the container
- `docker exec -it <container_name> bash`                          - Access a running container's shell 
^^^^^^^^
VERY USEFUL TO KNOW, ALSO DURING THE EVALUATION, ALLOWS YOU TO MANIPULATE THE SERVICE FROM WITHIN, LIKE LOOKING AT THE DATABASE
<br>

### Cleaning up docker

- `docker rm <container_name>`      - Remove a container (must be stopped first)
- `docker rmi <image_name>`         - Remove an image
- `docker system prune -af`[^6]     - Remove unused containers, networks, images
- `docker volume prune -af`         - Remove unused volumes
- `docker container prune -af`      - Remove stopped containers
- `docker image prune -af`          - Remove unused images

### Docker compose

- `docker-compose up`              - Start all services defined in docker-compose.yml
- `docker-compose up -d`           - Start in detached mode (background)
- `docker-compose down`            - Stop and remove containers
- `docker-compose ps`              - List running services
- `docker-compose logs -f`         - View logs of running services


[^1]: Use this one, it will show you if the container actually started and if it's still running, it might be some error occured and this is the first step identifying if if somehting went wrong.
[^2]: This is used for the nginx container to make it communicate with the host.
[^3]: This will just throw out whatever the programs in the container wrote to STDOUT and STDERR, so you can tell from these if or what went wrong.
[^4]: f.e. `docker cp ./nginx.conf nginx:/etc/nginx/http.d/default.conf`
[^5]: f.e. `docker cp nginx:/etc/nginx/http.d/default.conf ./nginx.conf`
[^6]: Your first tool for solving problems is this command and everything below it.