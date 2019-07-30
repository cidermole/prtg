#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$(dirname "${BASEDIR}")"

cd "${TOP}"
git checkout -- \
 app/prtg \
 app/tests \
 app/.pylintrc \
 app/pip/3.4/app/requirements.txt \
 README.md \
 LICENSE
