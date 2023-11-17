FROM ghcr.io/jumppad-labs/dind:v1.0.0

ARG NOMAD_VERSION
ARG TARGETARCH

ENV CNI_PLUGINS=1.3.0

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

COPY files/server.hcl /etc/nomad.d/server.hcl
COPY --chmod=0755 files/nomad.sh /usr/local/bin/nomad.sh

COPY files/nomad.conf /etc/supervisor/conf.d/nomad.conf