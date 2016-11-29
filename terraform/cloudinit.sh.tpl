#!/bin/bash

# Prepare the EBS device and use it as docker workspace
(file -s /dev/xvdk | grep -q ext4) || (mkfs.ext4 /dev/xvdk | tee /var/log/cloud-init-mkfs.log)

if [[ ! -d "/var/lib/docker" ]] ; then
  mkdir /var/lib/docker
fi

if ! grep -q "/var/lib/docker" /etc/fstab ; then
  echo "/dev/xvdk /var/lib/docker  ext4 defaults  0 0" >> /etc/fstab
fi

# Mount all mountpoints
mount -a

# Set the hostname to be the public IP address of the instance.
# If the call to myip fails, set a default hostname.
if ! curl --silent --fail http://myip.enix.org/REMOTE_ADDR >/etc/hostname; then
    echo dockerhost >/etc/hostname
fi

hostname $(cat /etc/hostname)

# Fancy prompt courtesy of @soulshake.
#echo 'export PS1="\[\033[0;35m\]\u@\H \[\033[0;33m\]\w\[\033[0m\]🐳 "' >> /etc/skel/.bashrc

# Create Docker user.
useradd -d /home/docker -m -s /bin/bash docker

echo docker:training | chpasswd

echo "docker ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/docker

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service ssh restart

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

cat > /etc/apt/sources.list.d/docker.list <<EOF
deb https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

apt-get -q update
apt-get -qy install docker-engine git jq httping

curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

systemctl stop docker && systemctl daemon-reload && sleep 5 && systemctl start docker

# Wait for docker to be up.
# If we don't do this, Docker will not be responsive during the next step.
while ! docker version
do
	sleep 1
done

# Pre-pull a bunch of images.
for I in \
	ubuntu:latest
do
	docker pull $I
done
