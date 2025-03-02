# Docker compose

I reccommend reading up on [Dockerfiles](./requirements/README.md) first.

## Contents

1. [What is docker-compose](#1-what-is-docker-compose)
2. [volumes](#2-volumes)
3. [networks](#3-networks)
4. [Elements and attributes](#4-elements-and-attributes)
5. [Command cheat-sheet](../assets/commands_cheat_sheet.md#docker-compose)

### 1. What is docker-compose

It's a tool to define and run multi-container applications (can also be used for one container, but it's rare I think).  
It allows for easy management of services, volumes and networks in a single file that you cna then run as a single command. You can think of it like a Makefile. A Makefile compiles files, sets flags, handles dependencies. A docker-compose file builds images, starts up containers, handles dependencies between containers and can set a bunch of extra options.<br>

In theory you could do eveyrhting a docker-compose file does with commands from the terminal. It's just a massive hassle remembering all the commands, flags and running them everytime you want to startup your application. Instead the docker-compose file has keywords and attributes you can use to define everything. A lot easier to read and change.

### 2. volumes

### 3. networks

### 4. Elements and attributes

### 5. [Command cheat-sheet](../assets/commands_cheat_sheet.md#docker-compose)
