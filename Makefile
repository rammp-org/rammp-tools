# Tool images. Built natively on the arm64 machine that runs them (abra, the
# demo Jetson); CI publishes the same images to GHCR.
#   make build          every image, tagged :dev
#   make foxglove       just one
#   make push TAG=v0.1.0
REGISTRY ?= ghcr.io/rammp-org/rammp-tools
TAG ?= dev
IMAGES := foxglove static_tf ffmpeg_decoder

.PHONY: build push $(IMAGES)

build: $(IMAGES)

$(IMAGES):
	docker build -t $(REGISTRY)/$@:$(TAG) docker/$@

push: build
	for i in $(IMAGES); do docker push $(REGISTRY)/$$i:$(TAG); done
