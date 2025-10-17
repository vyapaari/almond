FROM jupyter/scipy-notebook:latest

USER root

# Install AI platform essentials + keep some Scala dependencies for now
RUN apt-get update && apt-get install -y \
    proot \
    xclip \
    graphviz \
    unzip \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Install code-server for VS Code
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install jupyter-server-proxy for VS Code browser access
# RUN pip install jupyter-server-proxy

# Enable the proxy extension
# RUN jupyter server extension enable jupyter-server-proxy --py 

# Download VS Code icon for launcher

# ✅ FIXED: Use printf instead of heredoc to avoid syntax issues
# RUN mkdir -p /etc/jupyter && \
#    printf "c.ServerProxy.servers = {\n  'vscode': {\n    'command': ['code-server', '--auth', 'none', '--bind-addr', '0.0.0.0:{port}'],\n    'launcher_entry': {\n      'title': 'VS Code',\n      'icon_path': '/etc/jupyter/vscode.svg'\n    },\n    'port': 8080,\n    'absolute_url': False,\n    'timeout': 30,\n    'new_browser_tab': True\n  }\n}\n\nc.ServerApp.allow_remote_access = True\nc.ServerApp.allow_origin_pat = '.*'\n" > /etc/jupyter/jupyter_server_config.py

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
COPY --chown=$NB_UID:$NB_GID scripts/ ~/scripts/

USER root

# Create workspace for AI platform and added vscode icon
RUN mkdir -p ~/workspace && \
    curl -s -o /etc/jupyter/vscode.svg https://code.visualstudio.com/assets/images/code-stable.png  

# Create SSH directory structure
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    touch ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

WORKDIR ~/

# Start both services
 CMD code-server --auth none --bind-addr 0.0.0.0:8090 ~/workspace & jupyter-lab --ip=0.0.0.0 --port=8888 --NotebookApp.token=''
# Add to Dockerfile (before CMD)

# Simple CMD - .binder/start will override this
#CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--NotebookApp.token=''"]