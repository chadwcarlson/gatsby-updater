#!/usr/bin/env bash

set -e

yarn --ignore-optional --frozen-lockfile 
yarn build
