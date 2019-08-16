#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$(dirname "${BASEDIR}")"

cd "${TOP}"
git checkout -- \
 app/.isort.cfg \
 app/.pylintrc \
 app/setup.cfg \
 app/pip/3.4/app/requirements.txt \
 app/prtg \
 app/tests \
 app/.pylintrc \
 LICENSE
