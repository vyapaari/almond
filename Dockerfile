FROM jupyter/scipy-notebook:latest

USER root

# Install only essential dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    graphviz \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install almond kernel
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.13.8:0.13.2 \
      sh.almond:scala-kernel_2.13.8:0.13.2 \
      -o almond && \
    ./almond --install --id scala213 --display-name "Scala" && \
    rm almond coursier

COPY --chown=1000:100 notebooks/ /home/jovyan/
RUN mkdir -p /home/jovyan/{scala-tour,scalameta,visualization,TransmogrifAI}