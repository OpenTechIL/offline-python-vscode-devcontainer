#!/bin/bash

set -e 

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

pytest -v /home/vscode/py-apps/tests/

# .venv/bin/deactiveate

rm -rf .venv
