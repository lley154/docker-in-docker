# Use Ubuntu as base image
FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites and Docker
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    nano \ 
    sudo \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io

# Add ubuntu user to groups
RUN usermod -aG sudo ubuntu && \
    usermod -aG docker ubuntu

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create startup script with cleanup
RUN echo '#!/bin/bash\n\
# Cleanup any existing docker processes and files\n\
rm -f /var/run/docker.pid\n\
rm -f /var/run/containerd/containerd.pid\n\
killall containerd docker dockerd 2>/dev/null || true\n\
\n\
# Start services\n\
containerd & \n\
containerd_pid=$!\n\
sleep 2\n\
\n\
dockerd & \n\
dockerd_pid=$!\n\
sleep 2\n\
\n\
# Keep container running\n\
while kill -0 $containerd_pid $dockerd_pid 2>/dev/null; do\n\
    sleep 1\n\
done' > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/start.sh"] 
