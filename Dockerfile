FROM ubuntu:latest AS ubuntu-fresh
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y install sudo locales curl && \
  useradd -m user && \
  echo "user:user" | chpasswd && \
  adduser user sudo && \
  echo "Set disable_coredump false" >> /etc/sudo.conf && \
  localedef -f UTF-8 -i en_US en_US.UTF-8
WORKDIR /home/user
COPY ./install/init.sh .
RUN chown user:user ./init.sh
USER user
CMD /bin/sh

FROM ubuntu-fresh AS ubuntu-initialized
USER root
RUN apt-get -y install build-essential procps curl file git expect && \
  apt-get -y install bash libffi-dev locales && \
  apt-get -y install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
COPY ./test ./dotfiles
RUN chown user:user -R ./dotfiles
USER user


FROM centos:latest AS centos-fresh
ENV LC_ALL="C"
RUN yum -y update && yum -y install sudo curl && \
  useradd -m user && \
  echo "user:user" | chpasswd && \
  usermod -aG wheel user
WORKDIR /home/user
COPY ./install/init.sh .
RUN chown user:user ./init.sh
USER user
CMD /bin/sh

FROM centos-fresh AS centos-initialized
USER root
RUN yum -y groupinstall 'Development Tools' && \
  yum -y install procps-ng curl file git bash expect && \
  yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel \
    sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
COPY ./test ./dotfiles
RUN chown user:user -R ./dotfiles
USER user
