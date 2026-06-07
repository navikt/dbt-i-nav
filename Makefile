
SHELL = /bin/bash
.DEFAULT_GOAL = install

# Detect if uv is available, otherwise fall back to pip
UV_CMD := $(shell command -v uv 2>/dev/null)
ifdef UV_CMD
	PY = uv run python -m
	VENV_CREATE = uv venv .venv
	PIP_INSTALL = uv pip install
else
	PY = ./.venv/bin/python -m
	VENV_CREATE = python3 -m venv .venv
	PIP_INSTALL = ${PY} pip install
endif

.PHONY: install serve build package clean ## targets for local development

install: ## create venv (if missing) and install requirements
	if [ ! -d .venv ]; then ${VENV_CREATE}; fi
	${PIP_INSTALL} --upgrade pip
	${PIP_INSTALL} -r requirements-doc.txt

serve: install ## start lokal dev-server med live-reload
	${PY} zensical serve

build: install ## bygg statiske filer (site/)
	${PY} zensical build --clean

package: build ## lag zip-distribusjon dbt-i-nav-dist.zip
	cd site && zip -r ../dbt-i-nav-dist.zip .

clean: ## fjern venv, site og distribusjonspakker
	rm -rf .venv site dbt-i-nav-dist.zip
