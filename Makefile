SHELL := bash

.PHONY: fmt
fmt:
	terraform fmt -recursive
	terragrunt hcl fmt
