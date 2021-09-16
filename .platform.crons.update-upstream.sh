#!/usr/bin/env bash

set -e

# Update template from upstream once a week (1:11am EST).
if [ "$PLATFORM_BRANCH" = "$UPDATES_ENVIRONMENT" ]; then
    platform backup:create --yes --no-wait
    platform sync code data --yes --no-wait
    platform source-operation:run update-upstream
fi  
