#!/usr/bin/env bash

# Pyroscope
export PATH="${HOME}/usr/src/pyroscope/pyrocore/bin:${PATH}"
export PYRO_CONFIG_DIR="${HOME}/.config/pyroscope"
source "${PYRO_CONFIG_DIR}/bash-completion"

# Go packages / Gonic
export GOPATH="${HOME}/usr/go"
export PATH="${GOPATH}/bin:${PATH}"

# Dotnet (required for Emby)
export DOTNET_ROOT="${HOME}/usr/src/dotnet/6.0.10"
export PATH="${DOTNET_ROOT}:${PATH}"
