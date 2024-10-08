SHELL = /bin/bash
.DEFAULT_GOAL = install

PY = ./.venv/bin/python -m

.PHONY: install ## install requirements in virtual env
install:
	rm -rf .venv
	python3 -m venv .venv && \
		${PY} pip install --upgrade pip && \
		${PY} pip install -r requirements-doc.txt
