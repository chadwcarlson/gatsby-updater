#!/usr/bin/env bash

set -e

git status

rsync -aP .platform/template/files/ .
git add CODE_OF_CONDUCT.md
git status
git add .

git status

STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Upstream updates."
else
    echo "No upstream updates found. Skipping."
fi
