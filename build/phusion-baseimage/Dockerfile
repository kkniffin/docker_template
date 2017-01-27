FROM phusion/baseimage:latest

# Environment Variables
ENV DEBIAN_FRONTEND noninteractive

# Update System With Base Components
RUN apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
    && apt-get install -y curl \
    ntp \
    ntpdate \
    tzdata \
    wget \
    apt-transport-https \
    net-tools

# Copy Over System Services
RUN mkdir -p /etc/my_init.d
COPY ./my_init.d/ /etc/my_init.d/
COPY ./service/ /etc/service/

# Change Port to be Exposed
EXPOSE 9350

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

