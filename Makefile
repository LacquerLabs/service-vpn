.DEFAULT_GOAL := help
DOCKERSYNC := $(shell command -v docker-sync-stack 2> /dev/null)

ORG = lacquerlabs
NAME = simplevpn
IMAGE = $(ORG)/$(NAME)
VERSION = 0.0.1

build: ## creates the container
	docker build -t $(IMAGE):latest .

buildnocache: ## Build it without using cache
	docker build --no-cache -t $(IMAGE):latest .

run: ## run it attached
	docker run -v "${PWD}/etc/ppp/chap-secrets:/etc/ppp/chap-secrets" \
	-v "${PWD}/etc/ipsec.d/passwd:/etc/ipsec.d/passwd" \
	-v "${PWD}/etc/ipsec.secrets:/etc/ipsec.secrets" \
	--privileged --cap-add=ALL --name $(NAME)_run --rm -it $(IMAGE) /bin/sh

init:  ## Initialize etc and files and stuff
	mkdir -p ./etc/ipsec.d ./etc/ppp
	touch etc/ipsec.d/passwd
	touch etc/ppp/chap-secrets
	touch etc/ipsec.secrets

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"
