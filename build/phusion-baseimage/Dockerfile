FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive

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

RUN mkdir -p /etc/my_init.d
COPY ./my_init.d/ /etc/my_init.d/
COPY ./service/ /etc/service/

EXPOSE 9350

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

