#!/usr/bin/env bash

set -e

# Update dependencies every day (1:19am EST).
if [ "$PLATFORM_BRANCH" = "$UPDATES_ENVIRONMENT" ]; then
    platform backup:create --yes --no-wait
    platform sync code data --yes --no-wait
    platform source-operation:run update-dependencies
fi  
