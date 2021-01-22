FROM ubuntu:18.04
MAINTAINER Silent

RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git curl wget && \
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    apt-get install -qy openjdk-8-jdk && \
    apt-get install -qy python-dev build-essential libssl-dev libffi-dev python3-dev python3-pip python-pip libpq-dev && \
    apt-get -qy autoremove && \
    adduser --quiet silent && \
    echo "silent:silent123" | chpasswd 

#installing maven
RUN mkdir /home/silent/.m2 && \
    chown -R silent:silent /home/silent/.m2/ && \
    wget http://apache.mirror.digitalpacific.com.au/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -xzvf apache-maven-3.3.9-bin.tar.gz && \
    mv apache-maven-3.3.9 /opt/ && \
    update-alternatives --install /usr/bin/mvn maven /opt/apache-maven-3.3.9/bin/mvn 1001 && \
    mvn -v

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]