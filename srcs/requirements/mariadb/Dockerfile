FROM debian:bullseye

# server is for running the database service, creating databases, hosting them
# client provides command-line tools to connect to the server, it allows interacting with the database
RUN apt update && apt upgrade && apt install -y \
	mariadb-server \
	mariadb-client

# copy config and script to container and add proper permissions
COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/startup_script.sh /usr/local/bin/startup_script.sh
RUN chmod +x /usr/local/bin/startup_script.sh

# expose this port so other containers can connect to it
EXPOSE 3306

ENTRYPOINT ["startup_script.sh"]

CMD ["mysqld_safe"]

