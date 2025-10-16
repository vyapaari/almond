FROM jupyter/scipy-notebook:latest

USER root

# Install AI platform essentials + keep some Scala dependencies for now
RUN apt-get update && apt-get install -y \
    proot \
    xclip \
    openjdk-11-jdk \
    graphviz \
    unzip \
    docker \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Install code-server for VS Code
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER $NB_UID

# Keep Almond kernel for now (Binder compatibility)
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.13.8:0.13.2 \
      sh.almond:scala-kernel_2.13.8:0.13.2 \
      -o almond && \
    ./almond --install --id scala213 --display-name "Scala" && \
    rm almond coursier

# Copy our AI platform scripts
COPY --chown=$NB_UID:$NB_GID scripts/ /home/jovyan/scripts/

# Create workspace for AI platform
RUN mkdir -p /home/jovyan/workspace

# Start both Jupyter (port 8888) and VS Code (port 8080)
#CMD ["sh", "-c", "code-server --auth none --bind-addr 0.0.0.0:8080 /home/jovyan/workspace & start-notebook.sh"]
CMD ["sh", "-c", "nohup code-server --auth none --bind-addr 0.0.0.0:8080 /home/jovyan/workspace > /tmp/code-server.log 2>&1 & start-notebook.sh"]