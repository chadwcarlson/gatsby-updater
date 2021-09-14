#!/usr/bin/env bash

set -e

rsync -aP .platform/template/files/ .
git add CODE_OF_CONDUCT.md
