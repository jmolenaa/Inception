FROM debian:bullseye

# installing wget for getting the wordpress interface client, php just for php, php-fpm for fastcgi processing
# php-mysql for interacting with database and netcat for testing if the mariadb container is ready to go
RUN apt update && apt upgrade && apt install -y \
		wget \
		php \
		php-fpm \
		php-mysql \
		netcat

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/startup_script.sh /usr/local/bin/startup_script.sh

# php needs /run/php cause it puts information about the PID in there
# also adding permissions so we can run the startup script
RUN mkdir -p /run/php && chmod +x /usr/local/bin/startup_script.sh

# I do this, cause some weird permission stuff happens if I try to install wordpress
# first make the folder, since we haven't mounted the volume yet it doesn't exist
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# exposing port 9000 so nginx can send request through it
EXPOSE 9000

ENTRYPOINT ["startup_script.sh"]

CMD ["php-fpm7.4", "-F"]

