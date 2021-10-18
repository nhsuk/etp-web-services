SHELL=/bin/bash -euo pipefail

.PHONY: install-python install-node install lint clean publish serve check-licenses format release

install-python:
	poetry install

install-node:
	npm install

.git/hooks/pre-commit:
	cp scripts/pre-commit .git/hooks/pre-commit

install: install-node install-python .git/hooks/pre-commit

lint:
	npm run lint
	find . -name '*.py' -not -path '**/.venv/*' | xargs poetry run flake8

clean:
	rm -rf build
	rm -rf dist

publish: clean
	mkdir -p build
	npm run publish 2> /dev/null

serve:
	npm run serve

check-licenses:
	npm run check-licenses
	scripts/check_python_licenses.sh

format:
	poetry run black **/*.py

release: publish
	mkdir -p dist
	cp -R build/. dist/
