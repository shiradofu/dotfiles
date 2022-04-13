FROM ubuntu:latest AS u
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y install sudo locales curl \
  && useradd -m user \
  && echo "user:user" | chpasswd \
  && adduser user sudo \
  && echo "Set disable_coredump false" >> /etc/sudo.conf \
  && localedef -f UTF-8 -i en_US en_US.UTF-8
WORKDIR /home/user
COPY init.sh .
RUN chown user:user ./init.sh
USER user
CMD /bin/sh

FROM rockylinux:latest AS r
ENV LC_ALL="C"
RUN yum -y update && yum -y install sudo curl \
  && useradd -m user \
  && echo "user:user" | chpasswd \
  && usermod -aG wheel user
WORKDIR /home/user
COPY init.sh .
RUN chown user:user ./init.sh
USER user
CMD /bin/sh

# TODO: ghq
FROM linuxbrew/linuxbrew AS i
USER root
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y install sudo locales curl \
  && useradd -m user \
  && echo "user:user" | chpasswd \
  && adduser user sudo \
  && echo "Set disable_coredump false" >> /etc/sudo.conf \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && brew install ghq
WORKDIR /home/user
COPY . ./ghq/github.com/shiradofu/dotfiles
RUN chown -R user:user ./ghq/github.com/shiradofu/dotfiles
USER user
CMD /bin/sh
