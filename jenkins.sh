#!/bin/bash
dnf update -y
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install --nobest docker-ce -y
systemctl enable --now docker
# start docker.service
systemctl start docker
# pull jenkins image
docker pull jenkins/jenkins:lts
docker pull alpine/socat
# local jenkins home
mkdir -p /var/jenkins
chown 1000 /var/jenkins
# create Dockerfile with Jenkins, kubectl and Terraform inside
echo 'FROM jenkins/jenkins:lts
COPY --from=lachlanevenson/k8s-kubectl:v1.10.3 /usr/local/bin/kubectl /usr/local/bin/kubectl
USER root
RUN apt-get update && apt-get install -y \
    wget \
    unzip
RUN wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip \
  && unzip terraform_0.12.13_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && rm terraform_0.12.13_linux_amd64.zip
USER jenkins' \
> /root/Dockerfile
# build image
docker build -t my_jenkins /root
# run container from my_jenkins image
docker run -d -p 8080:8080 \
 -v /var/jenkins:/var/jenkins_home \
 --restart unless-stopped \
 my_jenkins:latest
# run container alpine/socat to be able use docker from Jenkins
docker run -d --restart=always \
    -p 127.0.0.1:2376:2375 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    alpine/socat \
    tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
# update Jenkins
container=$(sudo docker ps | grep my_jenkins | cut -c '1-12')
docker container exec -u 0 $container wget http://updates.jenkins-ci.org/download/war/2.190.3/jenkins.war
docker container exec -u 0 $container mv ./jenkins.war /usr/share/jenkins
docker container exec -u 0 $container chown jenkins:jenkins /usr/share/jenkins/jenkins.war
docker container restart $container
