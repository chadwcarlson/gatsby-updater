#!/usr/bin/env bash

set -e

git remote add upstream $UPSTREAM_REMOTE
                    
git fetch --all
git merge --allow-unrelated-histories -X theirs --squash upstream/master

rm package-lock.json
mv README.md README_UPSTREAM.md

# rsync -aP .platform/template/files/ .
cp .platform/template/files/README.md README.md

git add .
STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Upstream updates."
else
    echo "No upstream updates found. Skipping."
fi
