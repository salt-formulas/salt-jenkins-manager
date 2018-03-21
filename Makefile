VERSION = $(shell date +%Y%m%d)
ORGANIZATION ?= $(shell id -un)
SUDO ?= "sudo"

.PHONY: build push

build:
	$(SUDO) docker build --no-cache -t $(ORGANIZATION)/salt-jenkins-manager:$(VERSION) -f Dockerfile .
	$(SUDO) docker tag $(ORGANIZATION)/salt-jenkins-manager:$(VERSION) $(ORGANIZATION)/salt-jenkins-manager:latest

push:
	$(SUDO) docker push $(ORGANIZATION)/salt-jenkins-manager:$(VERSION)
	$(SUDO) docker push $(ORGANIZATION)/salt-jenkins-manager:latest
