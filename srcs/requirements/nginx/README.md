# Nginx

## Disclaimer

For some of this to make sense, you'll need some knowledge about [Dockerfiles](../README.md) and [secrets](../../data/variables/README.md), although the secrets can be ommited if you lazy.  
I also provide two Dockerfiles, one with secrets and using Alpine, the other with Debian and without secrets. You decide what you want.

## Contents

1. [Nginx explanation](#1-nginx-explanation)
	- [Short](#11-short)
	- [Long](#12-longerish-explanation)
	- [Flowchart](#13-flowchart)
2. [Nginx configuration file](#2-nginx-configuration-file)
3. [Nginx Dockerfile](#3-nginx-dockerfile)
4. [SSL/TLS certificate](#4-ssltls-certificate)

### 1. Nginx explanation

I won't explain all the theory behind this like HTTP requests and responses, the difference between HTTP and HTTPS, what webservers are etc. If you're interested the Internet is your friend.  
There are some references to PHP and wordpress in this doc, more about those [here](../wordpress/README.md)
Honestly you can skip this whole section if you don't care or already know this from webserv.

#### 1.1. Short

Nginx is the webserver of our stack. It's the point of entry to our infrastructure. In short, nginx is the program that receives the requests from clients, parses them, decides what needs to be done with them and then sends back a response to the client.  
We can configure nginx's behaviour with a [config file](#2-nginx-configuration-file)

#### 1.2. Longerish explanation

Whenever you type an address in your browser, you are sending a request to a webserver. To keep it simple let's just say you're requesting a page from the webserver. The page is written in HTML code, this code will be in a file somewhere on some computer. In our case these files are on the machine running the webserver.  
So essentially what Nginx does is that it receives the request, parses it, and then checks what the client asks for. Lets say it's file "x", Nginx will then look for file "x" in it's directory structure, read it and send the contents back to the client, which then displays that content.<br>

Now, noone is writing the content of all the webpages in the world manually. Let's say you have a page showing which hour it is. This doesn't mean you have 24 different files, each with a different hour. You will probably have one file with a script/function that runs to check what hour it is.  
Unfortunately Nginx is stupid and doesn't understand that there is a function in there. This is where PHP comes in, a scripting language that can read that file, run any functions in the file and use that to generate HTML code that will represent the page. In our case it will check what hour it is and just put a number in the HTML code.<br>

By default Nginx won't recognise these scripts (dynamic content). So we configure Nginx to use a proxy or FastCGI (dunno if these terms are interchangable, sue me). This means that Nginx instead of reading the file and just serving it back (static content) will ask a different program to process the file (dynamic content). Once it's done Nginx will send back the hard work of the other program to the client.<br>

In our case, the proxy is a different container, the [wordpress/php container](../wordpress/README.md). Now, you probably haven't set it up yet, so displaying dynamic content won't be possible, but that comes later.  
You might ask, how does Nginx differentiate between static and dynamic content. Well, we need to tell it through the configuration file. By default everything requested will be served statically as is. In our case we setup a rule that states if the file has a `.php` extension, then we send it to our proxy for processing. In theory you can do this for different kind of files as well, like `.py` files etc.  
How to do all this will be in the [next segment](#2-nginx-configuration-file).<br>

#### 1.3. Flowchart

![](../../../assets/Nginx_flowchart.jpg)

This is a simplified flowchart, a lot more happens, but for the purposes of the project and this container I hope it's enough to get an idea.<br>

A full flowchart of the infrastructure is available in the [docker-compose readme](../../README.md#flowchart).

### 2. Nginx configuration file

The config file already has short explanations. You can learn more here or just skip this section.
I'll explain the various lines from the configuration file in more detail here.  
The config file for reference:
```nginx
server {
	listen 443 ssl;
	listen [::]:443 ssl;
	server_name	jmolenaa.42.fr;
	
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_certificate /run/secrets/ssl_cert;
	ssl_certificate_key /run/secrets/ssl_key;

	root /var/www/html;
	index index.php index.html;


	location ~ \.php$ {
		fastcgi_pass wordpress:9000;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}
```
- **`listen 443 ssl;`** – Sets the server to listen on port 443 for IPv4 connections and enables SSL/TLS encryption.  
- **`listen [::]:443 ssl;`** – Sets the server to listen on port 443 for IPv6 connections and enables SSL/TLS encryption.
- **`server_name jmolenaa.42.fr;`** – Specifies the domain name that this server will handle requests for.  

- **`ssl_protocols TLSv1.2 TLSv1.3;`** – Specifies which **TLS (Transport Layer Security) versions** are allowed. In this case, it supports **TLS 1.2 and 1.3**, which are secure.  
- **`ssl_certificate /run/secrets/ssl_cert;`** – Defines the path to the **SSL certificate file**, which is used to encrypt traffic.  
- **`ssl_certificate_key /run/secrets/ssl_key;`** – Defines the path to the **private key** associated with the SSL certificate, used for decryption and authentication.  

- **`root /var/www/html;`** – Sets the **document root** where website files (HTML, PHP, etc.) are stored.  
- **`index index.php index.html;`** – Defines the **default files** to be served when a directory is requested. Nginx will try `index.php` first, then `index.html`.  

- **`location ~ \.php$ {`** – Defines a **location block** that handles all requests ending in `.php` (e.g., `index.php`).  
- **`fastcgi_pass wordpress:9000;`** – Forwards PHP requests to **PHP-FPM** running in a container named `wordpress` on **port 9000**.  
- **`fastcgi_index index.php;`** – Specifies that **`index.php`** should be used as the default file for directory requests in FastCGI.  
- **`include fastcgi_params;`** – Loads **predefined FastCGI parameters**, which help pass request details (like headers and environment variables) to PHP-FPM.  
- **`fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;`** – Sets the **full path** of the PHP script to be executed by PHP-FPM. It combines the `document_root` (`/var/www/html`) with the requested script name (`.php`).  



### 3. Nginx Dockerfile


### 4. SSL/TLS certificate
