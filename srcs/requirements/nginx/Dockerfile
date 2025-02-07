FROM alpine:3.19

# -y for apt-get to assume yes for any questions and run non-interactively
RUN apk update && apk add \
		bash \
		nginx \
		openssl

# generates a SSL key and certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /ssl_key \
	-out /ssl_cert \
	-subj "/C=NL/L=Amsterdam/O=CODAM/OU=student/CN=jmolenaa.42.fr"

# copying to http.d cause that's where virtual server blocks should be located for alpine nginx
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

# expose is more of a documentation thing, doesnt actually expose stuff
EXPOSE 443
# entrypoint since we always just want to start with nginx and it running in foreground
# this is to run nginx as not a daemon, but the main process in the container
ENTRYPOINT ["nginx", "-g", "daemon off;"]

# CMD nginx -g "daemon off;"