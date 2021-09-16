#!/usr/bin/env bash

set -e

UPSTREAM=$UPSTREAM_REMOTE
# UPSTREAM=$UPSTREAM_TEMPLATE

# Fetch upstream.
echo "- Retrieving upstream."
git remote add upstream $UPSTREAM
git fetch upstream
git merge --allow-unrelated-histories -X ours upstream/master
# git merge --allow-unrelated-histories -X ours --squash upstream/master

# Modify upstream.
echo "- Modifying upstream."
git clone $UPSTREAM upstream-repo
cp upstream-repo/README.md README_UPSTREAM.md 
rm -rf upstream-repo

# Update dependencies.
yarn upgrade

# Stage and commit.
git add .
STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Apply upstream updates."
else
    echo "No upstream updates found. Skipping."
fi
