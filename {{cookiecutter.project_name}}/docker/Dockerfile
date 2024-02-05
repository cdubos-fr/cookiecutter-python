FROM python:3.10-bookworm as base
LABEL maintainer="Clément Dubos"

ENV USERNAME=developer

# Install base packages
RUN apt update\
    && apt -y install \
        passwd sudo man-db \
        vim curl wget \
        zsh unzip pipx \
    && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && apt -qq clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


## Create user
RUN useradd -m -G sudo -s /bin/bash ${USERNAME} \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 440 /etc/sudoers.d/${USERNAME} \
    && chown -R ${USERNAME} /home/linuxbrew
## Switch to non-root user
USER ${USERNAME}

## Setup Shell
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew install starship just \
    && mkdir -p /home/${USERNAME}/.config \
    && wget https://raw.githubusercontent.com/cdubos-fr/gallifrey-war/main/gallifrey-war.toml \
        -O /home/${USERNAME}/.config/starship.toml
COPY .zshrc /home/${USERNAME}

USER root

RUN chsh -s $(which zsh) ${USERNAME}

USER ${USERNAME}

## Install Thirdparty dependencies
RUN pipx install pdm
RUN pipx install virtualenv
RUN pipx install virtualenvwrapper
RUN pipx install tox
RUN pipx install pre-commit

# Vagrant stage
FROM base as vagrant
USER root

RUN apt update \
    && apt -y install openssh-server

## Establish ssh keys for vagrant
RUN mkdir -p /home/${USERNAME}/.ssh; \
    chmod 700 /home/${USERNAME}/.ssh \
    && mkdir -p /run/sshd

ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/${USERNAME}/.ssh/authorized_keys
RUN chmod 600 /home/${USERNAME}/.ssh/authorized_keys; \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh

## Enable ssh for vagrant
RUN systemctl enable ssh.service;
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
