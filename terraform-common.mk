ENV_NAME := $(notdir $(shell cd $(PWD) && pwd))
ENV_SHORT ?= $(word 2,$(subst -, ,$(ENV_NAME)))
INFRA ?= $(word 1,$(subst -, ,$(ENV_NAME)))
ENV_TAIL ?= $(subst $(INFRA)-,,$(ENV_NAME))
TFVARS := $(PWD)/terraform.tfvars
TFSTATE := $(PWD)/.terraform/terraform.tfstate
TRAVIS_BUILD_COM_HOST ?= build.travis-ci.com
TRAVIS_BUILD_ORG_HOST ?= build.travis-ci.org
JOB_BOARD_HOST ?= job-board.travis-ci.com
AMQP_URL_VARNAME ?= AMQP_URL
TOP := $(shell git rev-parse --show-toplevel)

PROD_TF_VERSION := v0.11.1
TERRAFORM := $(HOME)/.cache/terraform-azurerm-cassandra/terraform-$(PROD_TF_VERSION)
TAR := tar

.PHONY: hello
hello: announce
	@echo "Would you like to:"
	@echo "  make plan"
	@echo "  make apply"

.PHONY: .echo-tf-version
.echo-tf-version:
	@echo $(PROD_TF_VERSION)

.PHONY: .echo-tf
.echo-tf:
	@echo $(TERRAFORM)

.PHONY: .assert-tf-version
.assert-tf-version:
	@TF_INSTALL_MISSING=0 $(TOP)/bin/ensure-terraform $(PROD_TF_VERSION)

.PHONY: announce
announce: .assert-tf-version
	@echo "This is env=$(ENV_NAME) (short=$(ENV_SHORT) infra=$(INFRA) tail=$(ENV_TAIL))"

.PHONY: apply
apply: announce $(TFVARS) $(TFSTATE)
	$(TERRAFORM) apply 

.PHONY: init
init: announce
	$(TERRAFORM) init

.PHONY: show
show: announce
	$(TERRAFORM) show

.PHONY: console
console: announce
	$(TERRAFORM) console

.PHONY: plan
plan: announce $(TFVARS) $(TFSTATE)
	$(TERRAFORM) plan 

.PHONY: destroy
destroy: announce $(TFVARS) $(TFSTATE)
	$(TERRAFORM) destroy

$(TFSTATE):
	$(TERRAFORM) init

.PHONY: clean
clean: announce
	$(RM) -r config $(TFVARS) $(ENV_NAME).tfvars

.PHONY: distclean
distclean: clean
	$(RM) -r .terraform/

.PHONY: graph
graph:
	$(TERRAFORM) graph -draw-cycles | dot -Tpng > graph.png

$(ENV_NAME).tfvars:
	$(TOP)/bin/generate-tfvars $@

.PHONY: list
list:
	 @$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

.PHONY: check
check:
	$(TOP)/bin/pre-flight-checks $@

config/.written:
	$(TOP)/bin/write-config-files \
		--infra "$(INFRA)" \
		--env "$(ENV_SHORT)" \
		--build-com-host "$(TRAVIS_BUILD_COM_HOST)" \
		--build-org-host "$(TRAVIS_BUILD_ORG_HOST)" \
		--job-board-host "$(JOB_BOARD_HOST)" \
		--amqp-url-varname "$(AMQP_URL_VARNAME)" $(WRITE_CONFIG_OPTS)

config/.gce-keys-written:
	cp -v $$TRAVIS_KEYCHAIN_DIR/travis-keychain/gce/*.json config/
	date -u >$@