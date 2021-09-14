#!/usr/bin/env bash

set -e

# Fetch upstream.
echo "****************** UPDATING TEMPLATE FROM UPSTREAM ****************** "
git remote add upstream $UPSTREAM_REMOTE              
git fetch --all
git merge --allow-unrelated-histories -X theirs --squash upstream/master
git status
git add .

# Modify upstream.
echo "****************** MODIFYING UPSTREAM FOR TEMPLATE ****************** "
rm package-lock.json
mv README.md README_UPSTREAM.md
git status
git add .

# Add template files.
echo "****************** UPDATING TEMPLATE FROM UPSTREAM ****************** "
cp -R .platform/template/files/. .
git status
git add .

# Commit.
STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Upstream updates."
else
    echo "No upstream updates found. Skipping."
fi
