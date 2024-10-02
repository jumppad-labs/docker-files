FROM ubuntu:22.04

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker LANG=C.UTF-8

RUN apt-get update && \
  apt-get install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  software-properties-common supervisor rsyslog iproute2 python3 python3-apt sudo bash ca-certificates \
  curl net-tools jq unzip vim dnsutils iputils-ping socat wget

# Setup bash
RUN sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd

# Setup supervisor
COPY files/supervisord.conf /etc/supervisor/supervisord.conf

# Setup docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
  "deb [arch=${TARGETARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  apt-get install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 docker-ce docker-ce-cli containerd.io && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# https://github.com/docker/docker/tree/master/hack/dind
ENV DIND_COMMIT d58df1fc6c866447ce2cd129af10e5b507705624

RUN set -eux; \
  wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind"; \
  chmod +x /usr/local/bin/dind

COPY --chmod=0755 files/dockerd.sh /usr/local/bin/dockerd.sh
COPY files/docker.conf /etc/supervisor/conf.d/docker.conf

VOLUME /var/lib/docker

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf"]