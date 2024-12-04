FROM ghcr.io/jumppad-labs/dind:v1.1.3

ARG NOMAD_VERSION
ARG TARGETARCH
ARG CNI_PLUGINS=1.5.1

RUN apt-get update && \
  apt-get install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  ca-certificates curl iptables apt-transport-https gnupg udhcpd fuse-overlayfs \
  unzip iproute2 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_${TARGETARCH}.zip -o /tmp/nomad.zip && \
  cd /tmp && \
  unzip nomad.zip nomad -d /usr/bin && \
  chmod +x /usr/bin/nomad && \
  rm /tmp/nomad.zip

# Install the CNI Plugins
RUN curl -L https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS}/cni-plugins-linux-${TARGETARCH}-v${CNI_PLUGINS}.tgz -o /tmp/cni.tgz && \
  mkdir -p /opt/cni/bin && \
  tar -C /opt/cni/bin -xzf /tmp/cni.tgz && \
  rm /tmp/cni.tgz

# Create the Nomad directory
RUN mkdir -p /var/lib/nomad

COPY files/config.hcl /etc/nomad.d/config.hcl
COPY --chmod=0755 files/nomad.sh /usr/local/bin/nomad.sh

ENTRYPOINT ["/usr/local/bin/nomad.sh"]