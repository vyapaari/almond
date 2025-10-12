FROM jupyter/scipy-notebook:latest

USER root
RUN apt-get update && apt-get install -y graphviz openjdk-11-jdk
USER $NB_UID

# Copy notebooks first
COPY --chown=1000:100 notebooks/ /home/jovyan/work/

# Copy and make postBuild executable (if it exists)
COPY binder/postBuild /tmp/postBuild
RUN if [ -f /tmp/postBuild ]; then chmod +x /tmp/postBuild && /tmp/postBuild; fi

# Install almond directly in Dockerfile (more reliable)
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.13.11:0.13.11 \
      sh.almond:scala-kernel_2.13.11:0.13.11 \
      -o almond && \
    ./almond --install --id scala213 --display-name "Scala (2.13)" && \
    rm almond coursier

# Verify installation
RUN jupyter kernelspec list
