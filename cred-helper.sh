#!/usr/bin/env bash

cat /dev/stdin > /dev/null

# `GLASS_RPC_CREDENTIALS` is provided as a secret.
echo "${GLASS_RPC_CREDENTIALS}"
