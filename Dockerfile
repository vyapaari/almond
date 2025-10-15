FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=jovyan
ENV HOME=/home/jovyan

# Install ONLY environment essentials
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    sudo \
    jq \
    procps \
    proot \                   # ← FIXED: Inside install list
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create user
RUN useradd -m -s /bin/bash -u 1000 jovyan && \
    mkdir -p /home/jovyan/workspace && \
    chown -R jovyan:jovyan /home/jovyan

USER jovyan
WORKDIR /home/jovyan

# Copy all scripts at once
COPY --chown=jovyan:jovyan scripts/ /home/jovyan/scripts/

EXPOSE 8080

# Simple start - just VS Code
CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "/home/jovyan/workspace"]