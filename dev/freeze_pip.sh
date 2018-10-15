#!/usr/bin/env bash

rm -Rf venv || true

mkdir -p $(pwd)/.history/

cp requirements.freezed.pip $(pwd)/.history/requirements.freezed.$(date +"%Y%m%d%H%M").pip || true

virtualenv venv
source $(pwd)/venv/bin/activate

pip install --upgrade --force-reinstall -r requirements.pip
pip freeze --disable-pip-version-check -q -r requirements.pip > requirements.freezed.pip

deactivate
rm -Rf venv
