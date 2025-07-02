echo "installing docker-compose"

echo "vm.max_map_count=262144" >> /etc/sysctl.conf

echo "configured vm.max_map_count=262144 at /etc/sysctl.conf"

wait 1

echo "installing docker engine"

curl -sSL https://get.docker.com/ | sh

wait 3

systemctl enable --now docker

curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

chmod +x /usr/bin/docker-compose