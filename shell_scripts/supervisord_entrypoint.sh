#!/usr/bin/env sh
set -e

#npm run build
#
#if [ $# -eq 0 ] || [ "${1#-}" != "$1" ]; then
#  set -- supervisord "$@"
#fi

mkdir -p /app/.ssh/etc /app/.ssh/run
cp /etc/ssh/sshd_config /app/.ssh/etc/
echo "Port 1220" >> /app/.ssh/etc/sshd_config
echo "HostKey /app/.ssh/etc/ssh_host_rsa_key" >> /app/.ssh/etc/sshd_config
echo "PidFile /app/.ssh/sshd.pid" >> /app/.ssh/etc/sshd_config
#echo "RSAAuthentication yes" >> /app/.ssh/etc/sshd_config
echo "AuthorizedKeysFile /app/.ssh/authorized_keys" >> /app/.ssh/etc/sshd_config
echo "PrintMotd no" >> /app/.ssh/etc/sshd_config
echo "PrintLastLog no" >> /app/.ssh/etc/sshd_config

if [ ! -f /app/.ssh/etc/ssh_host_rsa_key ]; then
    ssh-keygen -b 4096 -t rsa -f /app/.ssh/etc/ssh_host_rsa_key  -N ''
    cat /app/.ssh/etc/ssh_host_rsa_key.pub >> /app/.ssh/authorized_keys
fi

### and start sshd
/usr/sbin/sshd -p1220 -f /app/.ssh/etc/sshd_config -D -e &

exec "$@"
