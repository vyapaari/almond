FROM jupyter/scipy-notebook:latest

USER root
RUN apt-get update && apt-get install -y graphviz openjdk-11-jdk
USER $NB_UID

# Install almond
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.13.8:0.13.2 \
      sh.almond:scala-kernel_2.13.8:0.13.2 \
      -o almond && \
    ./almond --install --id scala213 --display-name "Scala" && \
    rm almond coursier

# Copy notebooks to Jupyter root
COPY --chown=1000:100 notebooks/ /home/jovyan/

# Create subdirectories
RUN mkdir -p /home/jovyan/{scala-tour,scalameta,visualization,TransmogrifAI}

RUN jupyter kernelspec list