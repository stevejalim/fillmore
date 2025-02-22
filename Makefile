DEFAULT_GOAL := help
PROJECT=fillmore

.PHONY: help
help:
	@echo "Available rules:"
	@fgrep -h "##" Makefile | fgrep -v fgrep | sed 's/\(.*\):.*##/\1:  /'

.PHONY: test
test:  ## Run tests
	tox

.PHONY: typecheck
typecheck:  ## Run typechecking
	mypy src/${PROJECT}/

.PHONY: lint
lint:  ## Lint and reformat files
	black --target-version=py38 --line-length=88 setup.py src tests docs
	flake8 setup.py src tests docs

.PHONY: clean
clean:  ## Clean build artifacts
	rm -rf build dist src/${PROJECT}.egg-info .tox .pytest_cache .mypy_cache
	rm -rf docs/_build/*
	find src/ tests/ -name __pycache__ | xargs rm -rf
	find src/ tests/ -name '*.pyc' | xargs rm -rf

.PHONY: docs
docs:  ## Builds Sphinx docs
	make -C docs/ clean html

.PHONY: checkrot
checkrot:  ## Check package rot for dev dependencies
	piprot -o requirements-dev.txt
	piprot -o requirements-ci.txt
