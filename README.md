# WORK IN PROGRESS

# Inception
This project focuses on creating a LEMP stack (Linux, Nginx, MySQl, PHP). It will help you understand containers, docker and how to deploy them using docker-compose. By completing this project you will also gain knowledge on the technologies used to build websites and web applications, like databases and webservers.

## Tutorial

### Introduction

I'm writing this guide/tutorial because I really liked this project and as it's a 42 project, there are requirements that are obscure, which means some information is hard to come by. I'm hoping I can shine some light on the project. <br>
This isn't a perfect step-by-step walkthrough, some things might be missing, omitted, badly explained or even wrong. I'm not an expert so don't take this as gospel, if you're not sure about something look it up. This also won't contain massive theoretical definitions. <br>
What this is is a collection of docs on all the separate aspects of the project, with explanations on how I tackled the various requirements and what all the lines of code actually mean. I will be writing colloquially, trying to convey how I understood all the aspects and hopefully it helps you too. Don't expect some formal or literary text, I'm too lazy to sanitize this. If you want to read some good prose i recommend David Mitchell. <br>

There is a lot of stuff to cover and a lot of code to explain, therefore I won't be keeping everything in one big README, but instead I'll split up the various segments into their own READMEs placed in the folders containing the concepts that they reference. I'll be referencing these READMEs wherever I can so you can switch between them and figure out what you need or don't. <br>

Also, the project can't really be split up into sections, since a lot of the various segments depend on knowledge of the other segments. This can get confusing. I'll be referring to other sections whenever some of the knowledge is required with links to that stuff, so there will be some hopping.<br>

I also did several things a bit differently from most of the other repositories out there, when that happens I'll try and give some explanations and how to adjust stuff if you don't want to bother. <br>

And last, because of the way we do this project it might be outdated in a year or two, especially the versions of the Linux distros I use. Keep this in mind 🙂.

### Contents
1. [VM setup](./VM_setup.md)
2. [Dockerfile, containers, images](./srcs/requirements/README.md)
3. Services
   - [nginx](./srcs/requirements/nginx/README.md)
   - [wordpress](./srcs/requirements/wordpress/README.md)
   - [mariadb](./srcs/requirements/mariadb/README.md)
4. [docker-compose](./srcs/README.md)
5. [secrets and environment](./srcs/data/variables/README.md)

### Order of operations

#### Order

Keep in mind, this is the order that worked for me, with the knowledge I had at the time. I started with nginx, cause I was already familiar with webservers after the webserv project. I you want to do it differently, feel free to :).

(Optional) Setup your VM. If you have a laptop with working Docker, please use it, it will probably be much faster than the machines at school, you can setup the VM as the last step. If you have a linux laptop the setup should work mostly the same as the [VM setup](./VM_setup.md) (don't quote me, I used a Mac). On Mac I had to install the docker client from the docker website, couldn't use brew for it, google how to install docker on Mac it shouldn't be hard.

1. Setup the [nginx](./srcs/requirements/nginx/README.md) container.
2. Setup the [wordpress](./srcs/requirements/wordpress/README.md) container.
3. Connect nginx to worpdress with [docker-compose](./srcs/README.md) and [volumes](./srcs/README.md#volumes).
4. Setup the [mariadb](./srcs/requirements/mariadb/README.md) container.
5. Figure out login credentials, database credentials and TLS/SSL with [secrets and env variables](./srcs/data/variables/README.md)
6. Connect wordpress to mariadb with [docker-compose](./srcs/README.md) and [volumes](./srcs/README.md#volumes).
7. Setup [network](./srcs/README.md#networks) for the containers to communicate.
8. [Setup VM](./VM_setup.md) if you haven't already.

#### Some tips and notes

- Again, keep in mind this whole thing might be outdated at this point
- Remember to use the penultimate stable version, which might have changed since I did this project (the Alpine version changed whilst I was doing the project)
- On Mac, if you docker commands don't work, you need the docker desktop application and it needs to be **running**
- You'll probably use the browser to test if things work. Keep in mind that modern browsers do a lot of stuff behind the scenes, particularly redirections. It might f.e. redirect any http request to https for you. Same with request to port 80, you might type localhost:80 and it will redirect it automatically to https://localhost:443. So I recommend using curl to test if your connections work properly
- If anything doesn't seem to work even though it used to, your first step should be pruning the system. This means getting rid of any lingering images, caches or anything else. Docker loves to cache and sometimes behaviour can be weird. For this I use:
```
docker stop docker ps -qa
docker builder prune -f && docker system prune -af
docker volume rm shell docker volume ls -q
```
This usually worked for me, if it isn't, well good luck 🫡


