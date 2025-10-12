FROM jupyter/scipy-notebook:latest

USER root
RUN apt-get update && apt-get install -y graphviz openjdk-11-jdk
USER $NB_UID

# Copy notebooks
COPY --chown=1000:100 notebooks/ /home/jovyan/work/

# Install almond with known working versions
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.13.6:0.10.9 \
      sh.almond:scala-kernel_2.13.6:0.10.9 \
      -o almond && \
    ./almond --install --id scala213 --display-name "Scala" && \
    rm almond coursier

# Create directories
RUN mkdir -p /home/jovyan/work/{scala-tour,scalameta,visualization,TransmogrifAI}

RUN jupyter kernelspec list