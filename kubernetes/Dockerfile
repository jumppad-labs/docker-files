ARG KUBERNETES_VERSION=v1.27.4

FROM rancher/k3s:${KUBERNETES_VERSION}-k3s1 AS base

COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENV PATH="$PATH:/bin/aux"
ENV CRI_CONFIG_FILE="/var/lib/rancher/k3s/agent/etc/crictl.yaml"

ENTRYPOINT ["/entrypoint.sh"]