
define HELP

This is the pytest testrail project Makefile.

Usage:
make requirements - Install dependencies
make clean        - Remove generated files
make coverage     - Run coverage analysis
make lint         - Run static analysis
make test         - Run static analysis, tests with coverage
make build        - Build new package version with setuptools
make push         - Push new version to pyPI

endef

export HELP

all help:
	@echo "$$HELP"

requirements: .requirements.txt

.requirements.txt: requirements/*.txt
	pip3 install -r requirements/base.txt
	pip freeze > $@

clean:
	rm -rf .cache .coverage .tox pytests_py*-test.xml pytest_testrail.egg-info pytest_testrail.txt pytests_coverage.xml build/ dist/ pytest_testrail_e2e.egg-info/
	find . -name '*.pyc' -delete

coverage:
	tox -e coverage

lint:
	flake8 pytest_testrail | tee pytest_testrail.txt

README.rst: README.md
	pandoc --from=markdown --to=rst --output=README.rst README.md

test: coverage lint
	tox

build:
	python3 setup.py sdist bdist_wheel

push:
	twine upload dist/*