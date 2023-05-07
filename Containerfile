ARG FEDORA_MAJOR_VERSION=37
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main

FROM ${BASE_IMAGE_URL}:${FEDORA_MAJOR_VERSION}
ARG RECIPE

# use linux-surface kernel
#RUN rpm-ostree cliwrap install-to-root / && \
#    wget -O /etc/yum.repos.d/linux-surface.repo https://pkg.surfacelinux.com/fedora/linux-surface.repo && \
#    wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm  && \
#    rpm-ostree override replace --remove=kernel-core --remove=kernel-modules --remove=kernel-modules-core --remove=kernel-modules-extra --remove=kernel-devel-matched ./*.rpm && \
#    rpm-ostree install surface-secureboot

#RUN rpm-ostree cliwrap install-to-root / && \
#    rpm-ostree override replace https://github.com/linux-surface/linux-surface/releases/download/fedora-38-6.2.13-1/kernel-surface-6.2.13-1.fc38.x86_64.rpm \
#                                https://github.com/linux-surface/linux-surface/releases/download/fedora-38-6.2.13-1/kernel-surface-devel-6.2.13-1.fc38.x86_64.rpm

# copy over configuration files
# etc is copied to /usr/etc/ to prevent "merge conflicts"
# as it is the proper directory for "system" configuration files
# and /etc/ is for editing by the local admin
# see issue #28 (https://github.com/ublue-os/startingpoint/issues/28)
COPY etc /usr/etc
COPY usr /usr

# copy scripts
RUN mkdir /tmp/scripts
COPY scripts /tmp/scripts
RUN find /tmp/scripts -type f -exec chmod +x {} \;

COPY ${RECIPE} /usr/etc/ublue-recipe.yml

# yq used in build.sh and the setup-flatpaks recipe to read the recipe.yml
# copied from the official container image as it's not avaible as an rpm
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# copy and run the build script
COPY build.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh && /tmp/build.sh

# clean up and finalize container build
RUN rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
