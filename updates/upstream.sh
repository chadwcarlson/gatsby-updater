#!/usr/bin/env bash

set -e

git remote add upstream $UPSTREAM_REMOTE
                    
git fetch --all
git merge --allow-unrelated-histories -X theirs --squash upstream/master

rm package-lock.json

git add .
STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Upstream updates found."
else
    echo "No upstream updates found. Skipping."
fi
