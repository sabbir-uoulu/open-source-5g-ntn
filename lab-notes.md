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
**Date:** 2026-05-15

Created `~/NTN-deployment/` with the following subdirectories, separating
*our work* (configs, docs, scripts, diagrams) from *third-party dependencies*
(external/):

- `docs/` — written deliverables; the Phase 3 architecture document lives in
  `docs/architecture/`
- `configs/` — our edited configs (not pristine upstream copies)
- `diagrams/` — sources (drawio, svg, mermaid) in `sources/`, rendered
  PDFs/PNGs in `exports/`
- `references/` — BibTeX file (`references.bib`), copies of cited 3GPP TS
  for offline reading
- `scripts/` — automation we write
- `notes/` — session notes and scratch
- `external/` — third-party repos. Intentionally separated and gitignored.
  Pinned commits recorded in `external/VERSIONS.md`. We do not redistribute
  upstream code; reproducibility is provided via commit pinning.

This separation is deliberate: any reader of the public repo can immediately
distinguish original work from integrated dependencies.

### Step 1: licensing and identity
**Date:** 2026-05-15

- Documentation licence: CC-BY-4.0 (LICENSE in repo root)
- Code licence: MIT (LICENSE-CODE in repo root)
- Git identity (global): `Sabbir Ahmed <sabbiraw.ahmed@gmail.com>`
- Repo initialised on `main` branch (not `master` — modern default)
- First commit: `60a78dc` — "Initial project skeleton"

### Step 2: clone and pin docker_open5gs
**Date:** 2026-05-15

Cloned the third-party orchestration layer:

```bash
cd ~/NTN-deployment/external
git clone https://github.com/herlesupreeth/docker_open5gs
```

Pinned commit: `7722ae2eba474f50e0255fde731d0785689e37a2` (2026-04-10).
Size: 3.5 MB. Recorded in `external/VERSIONS.md`.

**Why this repo and not the official `open5gs/open5gs` Docker setup?**
Three reasons:

1. `docker_open5gs` is the most widely cited deployment recipe in the
   OAI+Open5GS literature — using it makes our work directly comparable
   to published tutorials.
2. Cleaner PLMN / TAC / slice customisation surface — one `.env` file
   plus per-NF YAMLs, rather than a sprawling compose mesh.
3. Bundled WebUI for subscriber provisioning out of the box.

The trade-off: this is a community fork, not officially endorsed by Open5GS.
We pin the exact commit (above) so any future divergence is recorded.

### Step 3: edit YAML for PLMN/TAC/slice
TODO

### Step 4: bring up the core
TODO

### Step 5: provision test subscriber
TODO

### Step 6: verify
TODO
