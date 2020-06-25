FROM ubuntu:latest
RUN apt-get update && apt-get install -y sudo locales curl git && \
  useradd -m user && \
  echo "user:user" | chpasswd && \
  adduser user sudo && \
  echo "Set disable_coredump false" >> /etc/sudo.conf && \
  localedef -f UTF-8 -i en_US en_US.UTF-8
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"
USER user
WORKDIR /home/user
CMD /bin/bash

# docker run -it -v $(pwd):/home/user/dotfiles --rm <image-name>
