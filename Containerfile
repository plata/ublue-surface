# This is the Containerfile for your custom image.

# Instead of adding RUN statements here, you should consider creating a script
# in `config/scripts/`. Read more in `modules/script/README.md`

# This Containerfile takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

# !! Warning: changing these might not do anything for you. Read comment above.
ARG IMAGE_MAJOR_VERSION=38
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/kinoite-main

FROM ${BASE_IMAGE_URL}:${IMAGE_MAJOR_VERSION}

# The default recipe is set to the recipe's default filename
# so that `podman build` should just work for most people.
ARG RECIPE=recipe.yml 
# The default image registry to write to policy.json and cosign.yaml
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

# Install Surface kernel
RUN wget https://pkg.surfacelinux.com/fedora/linux-surface.repo -P /etc/yum.repos.d && \
    wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm -O \
    /tmp/surface-kernel.rpm && \
    rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace /tmp/surface-kernel.rpm \
        --remove kernel-core \
        --remove kernel-modules \
        --remove kernel-modules-extra \
        --remove libwacom \
        --remove libwacom-data \
        --install kernel-surface \
        --install iptsd \
        --install libwacom-surface \
        --install libwacom-surface-data

# Install akmods
COPY --from=ghcr.io/ublue-os/akmods:surface-${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

# Only run if FEDORA_MAJOR_VERSION is not 39
RUN if [ ${FEDORA_MAJOR_VERSION} -lt 39 ]; then \
    for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do \
        echo "akmods: enable default entry: ${REPO}" && \
        sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' ${REPO} \
    ; done && \
    rpm-ostree install \
        kernel-tools \
        /tmp/akmods-rpms/kmods/*xpadneo*.rpm \
        /tmp/akmods-rpms/kmods/*xpad-noone*.rpm \
        /tmp/akmods-rpms/kmods/*xone*.rpm \
        /tmp/akmods-rpms/kmods/*openrazer*.rpm \
        /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
        /tmp/akmods-rpms/kmods/*wl*.rpm && \
    for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do \
        echo "akmods: disable default entry: ${REPO}" && \
        sed -i '1,/enabled=1/{s/enabled=1/enabled=0/}' ${REPO} \
    ; done \
; fi

COPY cosign.pub /usr/share/ublue-os/cosign.pub

# Copy the bling from ublue-os/bling into tmp, to be installed later by the bling module
# Feel free to remove these lines if you want to speed up image builds and don't want any bling
COPY --from=ghcr.io/ublue-os/bling:latest /rpms /tmp/bling/rpms
COPY --from=ghcr.io/ublue-os/bling:latest /files /tmp/bling/files

# Copy build scripts & configuration
COPY build.sh /tmp/build.sh
COPY config /tmp/config/

# Copy modules
# The default modules are inside ublue-os/bling
COPY --from=ghcr.io/ublue-os/bling:latest /modules /tmp/modules/
# Custom modules overwrite defaults
COPY modules /tmp/modules/

# `yq` is used for parsing the yaml configuration
# It is copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    rm -rf /tmp/* /var/* && ostree container commit
