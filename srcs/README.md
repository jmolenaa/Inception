# Docker compose

I recommend reading up on [Dockerfiles](./requirements/README.md) first.

## Contents

1. [What is docker-compose](#1-what-is-docker-compose)
2. [volumes](#2-volumes)
3. [networks](#3-networks)
4. [Components and attributes](#4-components-and-attributes)  
	4.1. [Components](#41-components)  
	&emsp;4.1.1. [services](#411-services)  
	&emsp;4.1.2. [volumes](#412-volumes)  
	&emsp;4.1.3. [networks](#413-networks)  
	4.2. [Attributes](#42-attributes)  
	&emsp;4.2.1. [services attributes](#421-services-attributes)  
	&emsp;4.2.2. [volumes attributes](#422-volumes-attributes)  
	&emsp;4.2.3. [networks attributes](#423-networks-attributes)  
5. [Command cheat-sheet](../assets/commands_cheat_sheet.md#docker-compose)

### 1. What is docker-compose

It's a tool to define and run multi-container applications (can also be used for one container, but it's rare I think).  
It allows for easy management of services, volumes and networks in a single file that you can then run as a single command. You can think of it like a Makefile. A Makefile compiles files, sets flags, handles dependencies. A docker-compose file builds images, starts up containers, handles dependencies between containers and can set a bunch of extra options.<br>

In theory you could do everything a docker-compose file does with commands from the terminal. It's just a massive hassle remembering all the commands, flags and running them everytime you want to startup your application. Instead the docker-compose file has keywords and attributes you can use to define everything. A lot easier to read and change.<br>

In our case docker-compose uses the Dockerfiles we wrote to build the images and then runs them. But you could also use ready made images from Docker-hub, f.e. the nginx image. I think this is somehting you do in transcendence.

### 2. volumes

Volumes are a way to have persistent data for containers. Why do we need this? A container is build from an image. When you shut it down and start it up again it will use the same image as before, so it starts in the same state as the first time. This means that normally you'd lose any data that changed during the containers lifetime. A volume will persist between container lifetimes. <br>

So how does it work? <br>

A volume is pretty much a directory on your host machine that gets mounted to the container. So whenever something changes in your container (like a new entry in a database), it will also change in the directory on your host machine. Therefore next time you start up the container, the same directory, now with the changes gets mounted. That's pretty much it. <br>

Important is that this happens in real time. So if I change a thing in the container, that will immediately be changed on my host machine as well. I can also add things on my host machine which will then be reflected in the container.  
Another thing is that you can mount one volume into two separate containers, so any change in one container will also reflect on the other one. We'll be doing this in Inception.

### 3. networks

Networks are just a way for containers to communicate with each other or the outside world. We'll only be using a network to have the containers connect to eachother.

### 4. Components and attributes

A docker-compose file is written in yaml format and contains so called components and attributes. <br>

Components are top-level sections in which you can define certain aspects of your infrastructure, including: services (containers pretty much), volumes, networks, configs and secrets. We'll be using the services, volumes and networks.  
For each of these components you can then define multiple elements and configure them with attributes.  
f.e. for the services component you can define nginx, wordpress and mariadb and then separately configure them with attributes. <br>

Attributes are a way to configure the behaviour of the elements you're defining in your component. Say you're configuring your nginx container, you can use attributes to give it a name, open certain ports, mount volumes and much more.  
There is a lot of these so I'll only be covering the ones I used in the project. <br>

#### 4.1. Components

##### 4.1.1 Services
The services section defines the different containers (or services) in your Docker Compose setup. Each service runs in its own container, and you can configure them with various options such as how they are built, how they communicate with each other, and what ports they expose. f.e.  
```yaml
services:
  nginx:
    container_name: nginx
    build: ./nginx
```
[Services attributes](#421-services-attributes)

##### 4.1.2 Volumes
The volumes section defines persistent storage that Docker will use to store data, such as files or databases, across container restarts. Volumes are used to persist data outside of containers and share data between containers. f.e.  
```yaml
volumes:
  wordpress:
    driver: local
```
[Volumes attributes](#422-volumes-attributes)

##### 4.1.3 Networks
The networks section defines custom networks for the containers to communicate with each other. f.e.
```yaml
networks:
  mynetwork:
    driver: bridge
```

[Networks attributes](#423-networks-attributes)

#### 4.2. Attributes

##### 4.2.1. Services attributes
<br>

- **`container_name`** - allows you to specify a custom name for the container. By default, Docker generates a random name for each container, which is kinda meh and hard to manage. f.e.  
```yaml
container_name: nginx
```
<br>

- **`build`** - tells docker-compose to build a custom Docker image for the service from a specific directory containing a Dockerfile. You can specify the path to the directory or specify a custom Dockerfile. f.e.
```yaml
build: ./requirements/nginx
build: ./requirements/nginx/Dockerfile
```
<br>

- **`ports`** - maps the container's internal ports to the host machine's ports. This allows you to access the container's services from outside the container, such as through a web browser or API. f.e.
```yaml
ports:
       - "443:443"
```
<br>

- **`restart`** - defines the restart policy for the container. It controls what happens when the container stops or crashes. Common restart policies include:
	- no: Don't restart the container if it stops.
	- always: Always restart the container if it stops.
	- unless-stopped: Restart the container unless it's manually stopped.
	- on-failure: Restart the container only if it exits with a non-zero exit code. f.e.
```yaml
restart: unless-stopped
```
<br>

- **`env_file`** - loads environment variables from a file into the container. This pretty means that whatever is in the env_file will be exported into the shell environment inside the container. f.e.
```yaml
env_file:
  - .env
```
<br>

- **`volumes`** - mounts a volume to persist data or share data between containers. This can be a predefined volume from the [volumes component](#412-volumes) or you can mount a directory manually. If the volume is only used by a single service you don't have to predefine it with the volumes component, but because of the subject we will have to. I know this whole thing is confusing since the attribute and the component share the same name, sorry for that.  
When defining this attribute you cna use long syntax and short syntax. We'll be using the short one, you cna rea dmore on the internet if you want.  
The short syntax uses a single string with colon separated values in this format [`Volume:Container path`], f.e.
```yaml
 volumes:
      - wordpress:/var/www/html, or
      - /home/jmolenaa/data/wordpress:/var/www/html
```
<br>

- **`networks`** - defines which networks the service should be connected to. These have to be defined by the [networks component](#413-networks), f.e.
```yaml
networks:
       - inception
```

##### 4.2.2. Volumes attributes

- **`driver`** - specifies the type of volume to use. The default is local, which means the volume will be stored on the local disk of the host. There's a bunhc more, but we're only using local so I'm not explaining more. f.e.
```yaml
driver: local
```
<br>

- **`driver_opts`** - used to specify additional options for the volume driver. f.e.
```yaml
driver_opts:
      type: none
      device: /home/jmolenaa/data/database
      o: bind
```
<br>

##### 4.2.3. Networks attributes

Honestly don't know why I separated these, since there's only one but Oh well

- **`driver`** - specifies the type of network to use. The default is bridge, which creates a private network for containers to communicate.
```yaml
driver: bridge
```

### 5. [Command cheat-sheet](../assets/commands_cheat_sheet.md#docker-compose)
