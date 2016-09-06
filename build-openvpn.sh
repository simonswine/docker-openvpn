#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

# Name the ACI
acbuild --debug set-name simonswine/openvpn

# Based on alpine
acbuild --debug dep add quay.io/aptible/alpine:3.4

# Install nginx
acbuild --debug run apk update
acbuild --debug run apk add openvpn

echo '{ "set": ["CAP_NET_ADMIN","CAP_SETGID","CAP_SETUID"] }' | acbuild isolator add "os/linux/capabilities-retain-set" -

# Run nginx in the foreground
acbuild --debug set-exec -- /usr/sbin/openvpn /etc/openvpn/vpn.conf

# Save the ACI
acbuild --debug write --overwrite openvpn-linux-amd64.aci
