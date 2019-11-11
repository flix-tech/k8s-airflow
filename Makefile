.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -c

# -------------------------------------------------------
# -- ENV section
# -------------------------------------------------------

ENV ?= minikube
NAMESPACE ?= default
KUBE_CONTEXT ?= minikube
PROJECT_NAME ?= airflow
DOCKER_REGISTRY ?= ci-dump-dcr.mfb.io

# -------------------------------------------------------
# -- Command section
# -------------------------------------------------------

minikube.start:
	if minikube status | grep --fixed-strings --quiet "Running"; then echo "minikube is running"; else ./shell/start-minikube.sh; fi
	$(MAKE) set-kubernetes-context

minikube.reset:
	./shell/reset-minikube.sh

set-kubernetes-context:
	kubectl config set-context $(KUBE_CONTEXT) --namespace=$(NAMESPACE)
	kubectl config use-context $(KUBE_CONTEXT) --namespace=$(NAMESPACE)

build:
	docker build -t $(DOCKER_REGISTRY)/data/$(PROJECT_NAME):latest .
	#docker push $(DOCKER_REGISTRY)/data/$(PROJECT_NAME):latest

deploy: set-kubernetes-context
	$(MAKE) install.tillerless
	$(MAKE) deploy.airflow

install.tillerless:
	export NAMESPACE=$(NAMESPACE); ./shell/install-helm.sh

deploy.airflow:
	for f in ./helm-values/$(ENV)/*
	do
		# releasename is extracted from filename
		basename $$f .yaml
		# install Lenses with releasename based on filename
		helm tiller run $(NAMESPACE) -- helm upgrade $$(basename $$f .yaml) stable/airflow \
			--namespace $(NAMESPACE) \
			--install \
			--force \
			--wait \
			--timeout 600 \
			--values $$f
	done

purge.airflow:
	helm tiller run $(NAMESPACE) -- helm delete --purge airflow
