# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install systemd and other essential packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    dialog \
    systemd \
    systemd-sysv \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    nano \ 
    sudo \
    openssh-server \
    golang-go \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
        docker-ce=5:26.0.0-1~ubuntu.24.04~noble \
        docker-ce-cli=5:26.0.0-1~ubuntu.24.04~noble \
        containerd.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

# Add ubuntu user to groups
RUN usermod -aG sudo ubuntu && \
    usermod -aG docker ubuntu

# Remove unnecessary systemd services
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

# Configure container for systemd
VOLUME [ "/sys/fs/cgroup" ]

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'ubuntu:ubuntu' | chpasswd

# Expose SSH port
EXPOSE 22

# Set the default command to start systemd
CMD ["/lib/systemd/systemd"] 
