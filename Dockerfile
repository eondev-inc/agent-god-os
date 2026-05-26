FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias operativas puras
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    docker.io \
    docker-compose-v2 \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario agent sin root y con permisos sudo
RUN useradd -m -s /bin/bash agent && \
    echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG docker agent

USER agent
WORKDIR /home/agent

# Instalación de OpenCode y Engram (ajustar según el script oficial)
# RUN curl -fsSL https://opencode.dev/install | bash
# RUN curl -fsSL https://engram.dev/install | bash

WORKDIR /proyectos

CMD ["tail", "-f", "/dev/null"]
