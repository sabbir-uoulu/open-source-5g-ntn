# Lab Notes — NTN Deployment

Working log for the open-source 5G NR NTN testbed. Every command, every
design choice, every error and its resolution.

This file is the source for the Phase 3 architecture document. Write here
first, refine into the document later.

## Host
- Hostname: 6GR
- OS: Ubuntu 22.04
- Kernel: 6.8.0-111-generic (HWE)
- CPU: 20 cores
- RAM: 31 GB
- Disk: 938 GB total, 599 GB free at start
- Docker: 29.2.1, Compose v5.0.2
- Network: Wi-Fi only at the moment (wlo1, 192.168.0.106/24)
- Prior state: br-oai (192.168.70.0/24) and virbr0 (192.168.122.0/24) exist
  from prior libvirt and OAI work. Both DOWN at project start. Harmless.

## Pre-flight verification — date filled in below
- SCTP module: loaded (`modprobe sctp`)
- IPv4 forwarding: enabled (`net.ipv4.ip_forward = 1`)
- Target ports clear: 38412 (NGAP/SCTP), 2152 (GTP-U/UDP),
  9999 (Open5GS WebUI), 27017 (MongoDB), 3000 (Grafana), 9090 (Prometheus)
- No existing OAI / Open5GS / free5GC / srsRAN images or containers
- UE IP pool 10.45.0.0/16 has no host route collision

## Phase 1 — Open5GS 5G Core (in progress)

### Step 0: project skeleton
**Date:** TODO

Created `~/NTN-deployment/` with subdirectories:
- `docs/` — written deliverables; the Phase 3 architecture document
  lives in `docs/architecture/`
- `configs/` — *our* edited configs (not pristine upstream)
- `diagrams/` — sources (drawio, svg, mermaid) in `sources/`, rendered
  PDFs/PNGs in `exports/`
- `references/` — BibTeX file (`references.bib`), copies of cited 3GPP TS
  for offline reading
- `scripts/` — automation we write
- `notes/` — daily/session notes
- `external/` — third-party repos we depend on (Open5GS, OAI). Intentionally
  separated from our own work — this directory is gitignored. Pinned
  commits recorded in `external/VERSIONS.md`.

### Step 1: licensing and identity
**Date:** TODO

- LICENSE: CC-BY-4.0 (docs) and LICENSE-CODE: MIT (code)
- Git identity set globally: `Sabbir Ahmed <sabbiraw.ahmed@gmail.com>`
- Repo initialised on `main` branch

### Step 2: clone and pin docker_open5gs
TODO

### Step 3: edit YAML for PLMN/TAC/slice
TODO

### Step 4: bring up the core
TODO

### Step 5: provision test subscriber
TODO

### Step 6: verify
TODO
