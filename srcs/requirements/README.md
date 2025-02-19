# Dockerfile

Again, I'm not gonna really jump into the theory and explain everything in beautiful prose. There is plenty of info out there that can help you with this. I'll try to shortly explain some of the important stuff, explain the various command used in Dockerfiles and tell you about the order every Dockerfile follows.

## Contents

1. [Images, containers](#1-images-containers)
2. [What is a Dockerfile](#2-what-is-a-dockerfile)
3. [General order and setup of Dockerfiles](#3-general-order-and-setup-of-dockerfiles)
4. [Commands cheatsheet](../../assets/commands_cheat_sheet.md)

### 1. Images, containers

A container is similar to a VM, in that it runs separate from the host machine, is secure etc. etc. It is more lightweight and portable than a VM and can easily be shared during development within a team.  
The goal of a container is to have a way of deploying an application without worrying about the underlying machine. The container will have all the dependencies and files it needs for running the application. All this information is stored in an image.  
Think of an image as a blueprint for a container. It holds the information of the container, what packages are installed, what the filesystem might look like, port settings etc. The only thing you need to do to is share the image with someone, they can startup a container using this image and the application you made will run the exact same way it runs on your computer. (Provided the [environment variables](../data/variables/README.md) are set the same way and any [volumes](../README.md#volumes) have the same data in them.)  

An important thing about containers is that just like normal operating systems they have a first process that runs on startup. You will have to define this process that runs first and this will be the process with PID 1. Once this process ends, your container will be done and automatically stop. So if your first process was a program like Philosphers, your container would keep running until one of your philosophers died.  
So, if you want to keep your container running, which is required for Inception you'll need to start your containers with processes that run indefinitely in the foreground. 

### 2. What is a Dockerfile

A Dockerfile is pretty much just a script that executes commands in order to create an image. f.e. installing all the packages your application might need, giving permissions to certain files and defining the first process or **ENTRYPOINT** of your container (the process that runs first when your container starts up).  
A Dockefile also requires a base image from which to start. This might f.e. be a clean Linux Distribution where you'll have to get all the dependencies yourself or it might be an nginx image that already has base nginx installed and you'll just add extra functionality to suit your purposes.  

f.e. lets say you wanted to run your Philosophers program in a container. Your Dockerfile might start from a Debian image. It will then install gcc, and any C libraries you might need. Then it will clone your Philosophers repository and then run make inside it. Once that is done you can define your entrypoint as the ./philo program with certain default values as the input.  
Now you can use the Dokcerfile to build the image after which you can execute it to run your Philosophers project with it's default values or supply different values if you want.  
<br>
There is much more to this, but I hope that that example kind of tells you how you would use a Dockerfile. You can read up on it more if you want.

#### Commands/clauses

There is a lot of different commands you might use in a Dockerfile, I'll just cover the ones we will use

- **`FROM [image]`** - Defines the base image from which to start building, f.e. debian
- **`RUN [command]`** - This runs the specified command as if you were to type it in the terminal in the container, f.e. `apt install nginx`
- **`COPY [source] [destination]`** - Copies a file from your host machine (source) to a destination in your containers filesystem. We will use this for copying configuration files and scripts from our host machine to the containers
- **`EXPOSE [port]`** - This one is weird, cause as I understand it doesn't actually do anything. It is kind of documentation for the person reading the Dockerfile to know what port the applications inside the container will be listening on. If you want to use the port you have to publish it yourself, either through a command from the terminal or through the [docker-compose](../README.md) file. So, f.e. if I type `EXPOSE 443` in my nginx Dockerfile, a person using it will know nginx listens on that port and therefore that port needs ot be published for the container to work correctly
- **`ENTRYPOINT/CMD [command]`** - This defines the command that your container runs on startup. They're very similar and you could run one or the other in Inception. If you run both of them, then anything the `CMD` clause specifies will be sent as arguments to the `ENTRYPOINT` command. f.e. if your `ENTRYPOINT` command were to be `[./philo]` and your `CMD` command would be `["4", "400", "400", "900"] `, it is actually as if you ran `./philo 4 400 400 900`. The use case for this is that with the `CMD` clause you will set a default case to run, but you can overwrite this when you startup your container.  
It's complicated and not really useful in Inception, so you don't really have to know.

### 3. General order and setup of Dockerfiles

So specifically for the Inception project, each Dockerfile we write will follow the same structure of commands. This is just an order of operations executed in the Dockerfile to build the image. You can keep it in mind when writing the resepctive Dockerfiles.  

1. Define a base image with the `FROM` command. This will be either alpine:3.20 or debian:bullseye.
2. Update the package manager and install any packages necessary for the container with `RUN`.
3. Copy a configuration file to the container with `COPY`.
4. Copy a startup script to the container if applicable (wordpress and mariadb).
5. Change permissions and create directories necessary for the service to start (this is again for wordpress and mariadb, I'll explain it in their respective READMEs).
6. Expose ports.
7. Define the entrypoint of the container with `ENTRYPOINT` or `CMD` or both.

### 4. [Command cheatsheet](../../assets/commands_cheat_sheet.md)
