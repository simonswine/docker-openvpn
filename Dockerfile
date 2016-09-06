FROM quay.io/aptible/alpine:3.4

RUN apk update
RUN apk add openvpn

CMD ["/usr/sbin/openvpn", "/etc/openvpn/vpn.conf"]
