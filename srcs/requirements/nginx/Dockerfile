FROM alpine:3.19

# -y for apt-get to assume yes for any questions and run non-interactively
# TODO
# remove bsah install
RUN apk update && apk add \
		bash \
		nginx \
		openssl

# directory for ssl certificate and key for organization
RUN mkdir /home/ssl
RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout /home/ssl/jmolenaa.key -out /home/ssl/jmolenaa.cert -subj "/CN=jmolenaa.42.fr"

# copying to http.d cause that's where virtual server blocks should be located for alpine nginx
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

# expose is more of a documentation thing, doesnt actually expose stuff
EXPOSE 443
# entrypoint since we always just want to start with nginx and it running in background
# this is to run nginx as a daemon
ENTRYPOINT ["nginx", "-g", "daemon off;"]

# CMD nginx -g "daemon off;"