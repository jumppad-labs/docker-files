NOMAD_VERSION=1.9.3
CONSUL_VERSION=1.20.1
REPO=ghcr.io/jumppad-labs/nomad

build_main:
	docker build \
		-t ${REPO}:v${NOMAD_VERSION} \
		--build-arg NOMAD_VERSION=${NOMAD_VERSION} \
		-f ./Dockerfile \
		.

build_consul: build_main
	docker build \
		-t ${REPO}:v${NOMAD_VERSION}-consul \
		--build-arg NOMAD_VERSION=${NOMAD_VERSION} \
		--build-arg CONSUL_VERSION=${CONSUL_VERSION} \
		-f ./Dockerfile_Consul \
		.

build_java: build_main
	docker build \
		-t ${REPO}:v${NOMAD_VERSION}-java \
		--build-arg NOMAD_VERSION=${NOMAD_VERSION} \
		-f ./Dockerfile_Java \
		.

build_qemu: build_main
	docker build \
		-t ${REPO}:v${NOMAD_VERSION}-qemu \
		--build-arg NOMAD_VERSION=${NOMAD_VERSION} \
		-f ./Dockerfile_qemu \
		.

build_all: build_main
	docker build \
		-t ${REPO}:v${NOMAD_VERSION}-all \
		--build-arg NOMAD_VERSION=${NOMAD_VERSION} \
		--build-arg CONSUL_VERSION=${CONSUL_VERSION} \
		-f ./Dockerfile_all \
		.

build: build_main build_consul build_java build_qemu build_all