#!/usr/bin/env bash
#
# apply-open5gs-config.sh
#
# Applies our project-specific Open5GS configuration to the upstream
# docker_open5gs deployment directory.
#
# Pattern Y: our edited .env is the source of truth (configs/open5gs/.env).
# The upstream clone in external/docker_open5gs/ is kept pristine except for
# the .env we copy in here at deploy time. This script makes the deployment
# reproducible: anyone can run it to recreate our exact core configuration.
#
# Usage:
#   ./scripts/apply-open5gs-config.sh
#
# Then deploy from the upstream directory:
#   cd external/docker_open5gs
#   docker compose -f sa-deploy.yaml up -d
#
# Part of: open-source 5G NR NTN testbed. MIT licence (see LICENSE-CODE).

set -euo pipefail

# Resolve repo root regardless of where the script is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SRC="${REPO_ROOT}/configs/open5gs/.env"
DST="${REPO_ROOT}/external/docker_open5gs/.env"

# Sanity checks
if [[ ! -f "${SRC}" ]]; then
    echo "ERROR: source config not found: ${SRC}" >&2
    exit 1
fi

if [[ ! -d "${REPO_ROOT}/external/docker_open5gs" ]]; then
    echo "ERROR: upstream docker_open5gs not found. Clone it first:" >&2
    echo "  cd external && git clone https://github.com/herlesupreeth/docker_open5gs" >&2
    exit 1
fi

# Back up the upstream .env once, so we can always see the original
if [[ -f "${DST}" && ! -f "${DST}.upstream-baseline" ]]; then
    cp "${DST}" "${DST}.upstream-baseline"
    echo "Saved upstream baseline: ${DST}.upstream-baseline"
fi

# Apply our config
cp "${SRC}" "${DST}"
echo "Applied our config: ${SRC}"
echo "             -> ${DST}"
echo
echo "Next:"
echo "  cd external/docker_open5gs"
echo "  docker compose -f sa-deploy.yaml up -d"
