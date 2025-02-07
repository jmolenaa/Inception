#!/bin/bash

# waits until a ping to mariadb container actually works, meaning we mariadb container is finished setting up
while ! nc -zv $DATABASE_HOST $DATABASE_PORT; do
    echo "Waiting for MariaDB..." && sleep 3
done

# if our wp config doesn't exist we download and configure wordpress, using the command find
# cause volumes and cache act weird and wp-config.php can remain as a weird symbolic link on the volume
if [ ! `find /var/www/html -name wp-config.php` ]; then

	# download wordpress command line interface for wordpress setup
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar 
	mv wp-cli.phar /usr/local/bin/wp

	# change directory to where the html files are stored
	cd /var/www/html

	# running each command with --allow-root, since we're running stuff in a container,
	# normally you don't want to run as root, cause you're giving scripts rights to everything on your machine
	# installs core wordpress files
	wp core download --allow-root
	# creates the config file wp-config.php, required to connect to the database
	# needs the host, port, database name and a user with a password to work
	wp core config --dbhost="$DATABASE_HOST":"$DATABASE_PORT" --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USER" --dbpass="$DATABASE_USER_PSWD" --allow-root

	# this will install all the core functionality, initial configuration based on the database specified and an admin account
    wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PSWD" --admin_email="$WP_ADMIN_MAIL" --allow-root

    # creates a new user, as they want in the subject
    wp user create "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_USER_PSWD" --allow-root
	
	echo "Wordpress installed"
else
	echo "Wordpress already installed"
fi

# using exec is better, cause it replaces the bash script with the program being run
# this ensure that the program being run is PID 1 (the bash script is PID 1, cause it's used as the entrypoint)
exec "$@" # expands to the parameters given to the script, the quotes are there so they are separated into arguments
