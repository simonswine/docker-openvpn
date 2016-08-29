FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -y \
      openvpn && \
  apt-get clean autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
