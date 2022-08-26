FROM ubuntu:latest AS u
ENV LANG="en_US.UTF-8" \
  LANGUAGE="en_US:en" \
  LC_ALL="en_US.UTF-8" \
  DEBIAN_FRONTEND="noninteractive" \
  DEBCONF_NONINTERACTIVE_SEEN=true
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

# initialized
FROM u AS i
ENV HOMEBREW_NO_AUTO_UPDATE=1
USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update \
  && apt-get -y install build-essential procps curl file git bash \
  unzip \
  make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  && /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) \
  && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> /home/user/.bashrc \
  && chown user:user -R  $(brew --prefix)
USER user
RUN /home/linuxbrew/.linuxbrew/bin/brew install git ghq
COPY ./test ./ghq/github.com/shiradofu/dotfiles
USER root
RUN chown user:user -R ./ghq/github.com/shiradofu/dotfiles
USER user
CMD /bin/bash
