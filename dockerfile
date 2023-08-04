FROM ubuntu@sha256:9101220a875cee98b016668342c489ff0674f247f6ca20dfc91b91c0f28581ae

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PROJECT
run set -x ; [[ -n $PROJECT ]]
ENV PROJECT $PROJECT

RUN apt-get update && apt-get install --yes sudo recutils

ARG USER_UID
RUN set -x ; [[ -n $USER_UID ]]
ARG USER_GID
RUN set -x ; [[ -n $USER_GID ]]
RUN groupadd --system --gid $USER_GID ubuntu_user \
    && useradd --no-log-init --create-home --system --gid $USER_GID ubuntu_user \
    && echo ubuntu_user ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/ubuntu_user \
    && chmod 0440 /etc/sudoers.d/ubuntu_user
USER ubuntu_user
ENV HOME /home/ubuntu_user
RUN mkdir -p $HOME
RUN mkdir -p $HOME/${PROJECT}
WORKDIR $HOME/${PROJECT}

COPY --chown=ubuntu_user:ubuntu_user ./output/deb/ /opt/deb
COPY --chown=ubuntu_user:ubuntu_user ./other/test/docker/docker_test /usr/local/bin/docker_test

CMD ["bash"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ARG GIT_COMMIT
RUN set -x ; [[ -n $GIT_COMMIT ]]

ARG BUILD_DATE
RUN set -x ; [[ -n $BUILD_DATE ]]

# ✂ --------------------------------------------------
# Inject as envvars so they're accessible inside
ENV IMAGE_NAME="$IMAGE_NAME" \
    BUILD_DATE="$BUILD_DATE" \
    BUILD_URL="$BUILD_URL" \
    BUILD_NUMBER="$BUILD_NUMBER" \
    GIT_COMMIT="$GIT_COMMIT" \
    GIT_COMMIT_DATE="$GIT_COMMIT_DATE"

# Metadata
LABEL \
    org.opencontainers.image.title="$IMAGE_NAME"
# -------------------------------------------------- ✂

# vim: set filetype=dockerfile fileformat=unix nowrap spell spelllang=en,cdenglish01:
