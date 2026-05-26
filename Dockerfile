FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias operativas puras
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    docker.io \
    docker-compose-v2 \
    jq \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario agent sin root y con permisos sudo
RUN useradd -m -s /bin/bash agent && \
    echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG docker agent

# Instalar Engram (Última versión)
RUN curl -s https://api.github.com/repos/Gentleman-Programming/engram/releases/latest | \
    jq -r '.assets[] | select(.name | contains("linux_amd64.tar.gz")) | .browser_download_url' | \
    xargs curl -L -o engram.tar.gz && \
    tar -xzf engram.tar.gz engram && \
    mv engram /usr/local/bin/ && \
    rm engram.tar.gz

# Instalar Gentle AI (Última versión)
RUN curl -s https://api.github.com/repos/Gentleman-Programming/gentle-ai/releases/latest | \
    jq -r '.assets[] | select(.name | contains("linux_amd64.tar.gz")) | .browser_download_url' | \
    xargs curl -L -o gentle-ai.tar.gz && \
    tar -xzf gentle-ai.tar.gz gentle-ai && \
    mv gentle-ai /usr/local/bin/ && \
    rm gentle-ai.tar.gz

USER agent
WORKDIR /home/agent

# Instalar OpenCode usando el script oficial para el usuario agent
RUN curl -fsSL https://opencode.ai/install | bash

# Asegurar que el PATH del agent incluya el binario de opencode (que suele instalarse en ~/.opencode/bin o ~/.local/bin)
ENV PATH="/home/agent/.opencode/bin:/home/agent/.local/bin:${PATH}"

WORKDIR /proyectos

CMD ["tail", "-f", "/dev/null"]
