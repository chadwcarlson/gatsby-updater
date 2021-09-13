#!/usr/bin/env bash

set -e

# Fetch upstream.
git remote add upstream $UPSTREAM_REMOTE              
git fetch --all
git merge --allow-unrelated-histories -X theirs --squash upstream/master

# Modify upstream.
rm package-lock.json
mv README.md README_UPSTREAM.md
rsync -aP .platform/template/files/ .
git add CODE_OF_CONDUCT.md

# Commit.
.platform/updates/commit.sh "Upstream updates."

# git add .
# STAGED_UPDATES=$(git diff --cached)
# if [ ${#STAGED_UPDATES} -gt 0 ]; then
#     git commit -m "Upstream updates."
# else
#     echo "No upstream updates found. Skipping."
# fi
