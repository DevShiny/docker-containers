FROM phusion/baseimage:0.9.18
MAINTAINER devshiny <info@devshiny.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

ENV VERSION         1.8

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME            /root
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Set the GIT_USER variable. It will be used to download files and updates
ENV GIT_USER devshiny

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

# Files
# Add default config
ADD eggdrop.default.conf /opt/eggdrop/eggdrop.default.conf

# Add services to runit
ADD eggdrop.sh /etc/service/eggdrop/run

RUN chmod +x /etc/service/*/run /etc/my_init.d/*


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

# VOLUMES
VOLUME /config
VOLUME /logs

# PORTS
EXPOSE 3333


#########################################
##         RUN INSTALL SCRIPT          ##
#########################################

# Add build script
ADD build.sh /opt/
RUN chmod +x /opt/build.sh
RUN /opt/build.sh
