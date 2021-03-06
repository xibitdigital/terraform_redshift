SHELL = /bin/sh

.PHONY: install

all: install

install:
	brew install pre-commit tflint terraform-docs
	pre-commit install
	pre-commit install-hooks

run_precommit:
	pre-commit run --all-files
