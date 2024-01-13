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

# Music Organizer (bash scripts)
export PATH="${HOME}/usr/src/music-organizer/bin:${PATH}"
export MUSICBOX_LIBRARY_PATH="${HOME}/data/media.library/audio/music"
export MUSICBOX_TRUMP_PATH="${HOME}/data/media.library/audio/staging"
