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

# cat package.json | jq -r '.name = "gatsby-starter-blog-platformsh"' \
#             | jq -r '.description = "A Platform.sh starter project for a blog powered by Gatsby and Markdown"' \
#             | jq -r '.author = "Platform.sh"' \
#             | jq -r '.bugs.url = "https://github.com/chadwcarlson/gatsby-updater/issues"' \
#             | jq -r '.homepage = "https://github.com/chadwcarlson/gatsby-updater#readme"' \
#             | jq -r '.repository.url = "git+https://github.com/chadwcarlson/gatsby-updater.git"' \
#             > package.json

# cat package-lock.json | jq -r '.name = "gatsby-starter-blog-platformsh"' \
#             > package-lock.json


# # Update dependencies & verify builds.
# yarn upgrade
# rm -rf node_modules && rm package-lock.json 
# npm install
# npm update

# # Format changes.
# yarn format

# Stage and commit.
git add .
STAGED_UPDATES=$(git diff --cached)
if [ ${#STAGED_UPDATES} -gt 0 ]; then
    git commit -m "Apply upstream updates."
else
    echo "No upstream updates found. Skipping."
fi
