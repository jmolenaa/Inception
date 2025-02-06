# VM setup

## Contents

1. [Distribution choice](#1.-distribution-choice)
2. [Package instalation](#2.-package-instalation)
3. [ssh setup](#3.-ssh-setup)
4. [Extra information](#4.-extra-information)
	- [curl](#4.1-curl)
	- [docker](#docker)

### 1. Distribution choice

So I just chose Ubuntu since it's easy. Didn't put a whole lot of thought into it tbh. You can do something else , I believe everything should work the same way. I would recommend at least something with a graphical environment.  
I won't explain the whole instalation of the VM, I'm sure all your knowledge from Born2beRoot is still there. It's pretty much just press next on everything. The hostname doesn't matter, just make sure the username is your intra login (I don't think the username has to be that, but the subject is ambiguous so just be safe).  Use an easy password for your own sanity.  
Give it as much resources as the green bar allows. And give it some extra space, like 70-80GB.  
Also, when virtual box starts up, go to View->Scaled Mode so you can make the window big.

### 2. Package instalation

So, these are packages that you'll be needing for the project and some are just for testing or making things easier.  
```
apt install curl openssh-server docker-compose git python3-setuptools openssl vim make
```
- curl - install this just for testing if your port setup is correct, [extra info](#curl)
- openssh-server - install this if you want to use ssh to connect to your VM, be it through the terminal or through VSCode
- docker-compose - this one so you can run the containers, requires some extra [setup](#docker)
- git - this is for the evaluation so you can clone the repository, also you might use it for pushing to the repository
- python3-setuptools - this is necessary to run docker stuff[^1]
- openssl - this is for generating the SSL/TSL certificate, not strictly necessary since you can just generate them in the container, but I'll explain that [elsewhere](./srcs/requirements/nginx/README.md#SSL/TLS-certificate)
- vim - you can use nano as well
- make - well, you need it to use the Makefile

### 3. ssh setup

So this one isn't strictly necessary, it will allow you to connect to the VM via the terminal or as I will explain via VSCode if you so please. This will make working on the project a bit easier, since you'll be able to copy paste things a lot easier.  

1. Setup port forwarding from your VM to the host machine. To do this you can go to VirtualBox, select your VM, go to the settings, go to Network->Advanced->Port Forwarding. In this window add a new rule and connect any to port from your host to any port on your VM, f.e. 5555 to 5555.
2. Install openssh-server on your VM via apt as explained above.
3. Modify the file /etc/ssh/sshd_config. Find the line `#Port 22`, uncomment it and change it to the port that you forwarded f.e. `Port 5555`.
4. If your firewall is enabled, allow your port of choice `sudo ufw allow [port]`.
5. Restart VM.
6. Now you should be able to connect to the VM from your host machine with the command `ssh -p [port] [login]@localhost`, changing the port to whatever you configured and the login to the name of your VM account.

Connecting via VSCode
Again, not strictly necessary, but this will allow you to use VSCode on your host machine to work on the project with all the advantages that brings.

1. Add the `Remote - SSH` extension to your VSCode.
2. Press CTRL+Shift+P and run the `Remote-SSH: Connect to Host...` command.
3. Enter your user, host and port when prompted in this format `[user]@localhost:[port]`, f.e. `jantje@localhost:5555`.
4. You'll be prompted in a new window to confirm you trust the host and then your password.
5. You should now be connected to the VM and can use the integrated terminal of VSCode and the filesystem within it.

### 4. Extra information

These are some more notes on some of the setup and/or applications and what they're used for. Some of this is optional, some is important for the setup

#### 4.1 curl

So, because browsers are kinda fancy nowadays, your browser will probably redirect the url http://localhost:80 to https://localhost:443, which makes it look like you can connect to your website on port 80. This is a problem since the eval sheet specifically asks to test this and says it should not be possible. Now, there's probably a way to turn this off in the browser or do some fancy smancy thing, but you can just use the `curl` command to show that the connection gets refused.  
Now, I've got an [nginx test](./nginxtest.sh) that runs a couple tests with curl to check if the connections work, but I'll write out what you can test here as well:  
- `curl localhost:80` - just test port 80
- `curl https://localhost:80` - test it through an https
- `curl localhost:443` - test the port it's actually supposed to work on, but it's an HTTP instead of an HTTPS, so it should return a Bad Request
- `curl https://localhost:443` - send it through HTTPS, this shouldn't work if you already setup the [SSL/TLS certificate](./srcs/requirements/nginx/README.md#SSL/TLS-certificate).
- `curl -k https://localhost443` - ignores the self signed certificate and should return your webpage

Just keep these handy for the evaluation or test with it yourself to make sure everything works as intended.

#### 4.2 docker

So, docker needs permissions to run. You could just use sudo when running it to give it permissions, but that's a bit ugly.  
Instead you can add your user to the `docker` group, so you will have permissions for the docker daemon. It's just a single command:  
`sudo usermod -aG docker [login]`
And then another command to update the group:  
`newgrp docker`
And that should make it work


[^1]: some python stuff that our version of docker is running is deprecated so docker-compose won't run, you could also alternatively install the docker-compose-v2 package, but I'm not sure that's subject compliant