FROM ghcr.io/jumppad-labs/dind:v1.1.2

ARG NOMAD_VERSION
ARG TARGETARCH

ENV CNI_PLUGINS=1.5.1

RUN apt-get update && \
  apt-get install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
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

# Enable all repositories.
RUN apt-get update && \
  apt-get install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  software-properties-common supervisor rsyslog iproute2 python3 python3-apt sudo bash ca-certificates \
  curl net-tools jq unzip vim dnsutils iputils-ping socat \
  iptables \
  apt-transport-https \
  gnupg \
  lsb-release \
  wget \
  qemu-system-x86 \
  udhcpd \
  iproute2 \
  git \
  fuse-overlayfs && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Add java
RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; \
  case "${ARCH}" in \
  aarch64|arm64) \
  ESUM='3447ec27a6dbd4f3a6180a0d4371bb09aa428c16eea9983e515a7400cc9f5c85'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.1_9.tar.gz'; \
  ;; \
  armhf|armv7l) \
  ESUM='20fc395d8ea2659e6407cd4ec233dc4399f61b7610f3a16495deb23c1e3b81df'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_arm_linux_hotspot_16.0.1_9.tar.gz'; \
  ;; \
  ppc64el|ppc64le) \
  ESUM='8d8e35ca5a7e24f16384bf32b110562921c19b4cfe65969980937bf879462bc6'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_ppc64le_linux_hotspot_16.0.1_9.tar.gz'; \
  ;; \
  s390x) \
  ESUM='421cd44661cdbf0c2da79ab3104c81a1fa171b974038e55b1b3d4a042865588f'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_s390x_linux_hotspot_16.0.1_9.tar.gz'; \
  ;; \
  amd64|x86_64) \
  ESUM='7fdda042207efcedd30cd76d6295ed56b9c2e248cb3682c50898a560d4aa1c6f'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz'; \
  ;; \
  *) \
  echo "Unsupported arch: ${ARCH}"; \
  exit 1; \
  ;; \
  esac; \
  curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
  echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
  mkdir -p /usr/lib/jvm/openjdk; \
  cd /usr/lib/jvm/openjdk; \
  tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
  rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/usr/lib/jvm/openjdk PATH="/usr/lib/jvm/openjdk/bin:$PATH"

# Create the Nomad directory
RUN mkdir -p /var/lib/nomad

COPY files/config.hcl /etc/nomad.d/config.hcl
COPY --chmod=0755 files/nomad.sh /usr/local/bin/nomad.sh

ENTRYPOINT ["/usr/local/bin/nomad.sh"]