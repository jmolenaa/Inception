#!/bin/bash

if [ ! `find /var/lib/mysql -name $DATABASE_NAME` ]; then

	# we need to startup the server temporarily to create the database
	service mariadb start

	# we wait 2 seconds for the service to startup, had issues otherwise
	sleep 2

	# we use a heredoc to send all the instructions for creating a database to mariadb
	# we use IF NOT EXISTS, to make it easier in setup when this command might be called mutltiple times
	# normally mariadb would error out, in this case it just ignores the instruction if f.e. the database already exists
	# the syntax for creating the user '$MARIA_USER'@'%', stands for 'username'@'host'
	# in this case we use % as a wildcard for the user to be able to connect from any IP address
	# it needs single quotes cause syntax
	# then for the GRANT ALL PRIVILEGES, $MARIA_DATABASE.*, this stands for [database].[tables],
	# so in our case we're granting the user privileges to only the wordpress database and to all tables in it.
	# you could also grant *.* which would give permissions to all databases on the server
	# flush privileges is for updating everything	
	mariadb << EOF
	CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;
	CREATE USER IF NOT EXISTS '$DATABASE_USER'@'%' IDENTIFIED BY '$DATABASE_USER_PSWD';
	GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER'@'%';
	FLUSH PRIVILEGES;
EOF

	# stop mariadb, will start it up again at the end of the script
	service mariadb stop
	echo Database created
else
	echo Database already exists
fi

# sooo, multiple things
# 1.	our wordpress container is pingning mariadb container to check if it's done setting up the database
# 		only then will the wordpress container continue with it's own shenanigans
# 2.	to setup the database we need to startup mariadb temporarily, then stop it
# 		and eventually replace the bash script with the mariadb proccess
# So what happens is that wordpress might ping mariadb whilst it's temporarily enabled, but the database is not setup yet
# What I do is that the config file I copy from the host machine hast a bind-adress of 127.0.0.1 (localhost),
# this means that other containers cannot connect to mariadb
# in the line below I replace the bind-address line with 0.0.0.0, so when I startup mariadb again, now the configuration
# allows any container to connect, since now it's safe, cause the database is set up
sed -i 's/bind-address\s*= 127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# using exec is better, cause it replaces the bash script with the program being run
# this ensure that the program being run is PID 1 (the bash script is PID 1, cause it's used as the entrypoint)
exec "$@" # expands to the parameters given to the script, the quotes are there so they are separated into arguments