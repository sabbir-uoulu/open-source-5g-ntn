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

### Step 3: project configuration (Pattern Y)
**Date:** 2026-05-21

Rather than editing the upstream `.env` in place, we keep the upstream clone
pristine and layer our own config on top:

- Our edited config: `configs/open5gs/.env` (tracked in git)
- Upstream baseline: `external/docker_open5gs/.env.upstream-baseline` (gitignored)
- Apply script: `scripts/apply-open5gs-config.sh` copies our config into the
  deploy directory and saves a one-time baseline backup.

Deviations from the stock docker_open5gs `.env`:

| Variable | Stock | Ours | Reason |
|---|---|---|---|
| TAC | 1 | 7 | Must match OAI gNB tracking_area_code in Phase 2 |
| DOCKER_HOST_IP | 192.168.1.223 | 192.168.0.106 | This host (wlo1) |
| UE1_IMSI | ...567895 | 001010000000001 | OAI default; avoids editing OAI UE later |
| UE1_KI | 8baf... | fec8...4b8f | OAI default test key |
| UE1_OP | 1111... | UE1_OPC C424...7CC1 | OAI default OPc (note OP->OPc) |

PLMN kept at MCC=001 MNC=01 (3GPP reserved test PLMN). UE IPv4 pool kept at
192.168.100.0/24 (no host route collision). The UE1_* values are not consumed
by the 5G SA deployment path (they feed UERANSIM, which we are not using);
the authoritative subscriber is created in the Open5GS web interface (Step 5).

We chose the `sa-deploy.yaml` recipe (5G SA only) from the several deployment
files the repo provides. It brings up 15 containers: the core NFs (nrf, scp,
ausf, udr, udm, amf, smf, upf, pcf, bsf, nssf), plus mongo (subscriber DB),
webui (provisioning), and a metrics+grafana monitoring pair.

### Step 4: bring up the core
**Date:** 2026-05-21

Pulled pre-built images from ghcr.io and tagged them to the short names the
compose file expects:

```bash
docker pull ghcr.io/herlesupreeth/docker_open5gs:master
docker tag  ghcr.io/herlesupreeth/docker_open5gs:master docker_open5gs
docker pull ghcr.io/herlesupreeth/docker_grafana:master
docker tag  ghcr.io/herlesupreeth/docker_grafana:master docker_grafana
```

The `docker_metrics` image is not published pre-built, so compose built it
locally on first launch (downloads Prometheus 3.5.0). Open5GS version baked
into the image: v2.7.6-131-g782a97e.

Launch:

```bash
./scripts/apply-open5gs-config.sh
cd external/docker_open5gs
docker compose -f sa-deploy.yaml up -d
```

Result: all 15 containers Up. Key listeners confirmed:
- AMF NGAP/SCTP on 172.22.0.10:38412 (radio-facing, for the gNB in Phase 2)
- UPF GTP-U on 2152/udp (N3 user plane)
- WebUI on host port 9999; Grafana on 3000; metrics on 9090

The NRF logged "NF registered [Heartbeat:10s]" for each NF, confirming the
Service-Based Architecture mesh formed correctly.

### Step 5: provision test subscriber
**Date:** 2026-05-21

Created one subscriber via the Open5GS web interface (http://localhost:9999,
default login admin/1423):

- IMSI: 001010000000001
- K: fec86ba6eb707ed08905757b1bb44b8f
- USIM type: OPc (NOT OP) -> C42449363BBAD02B66D16BC975D77CC1
- DNN/APN: internet, S-NSSAI SST 1, IPv4v6

The OPc-vs-OP distinction is the most common silent failure: entering an OPc
value while the USIM type is set to OP causes authentication to fail later
with a misleading NAS reject. Verified correct below.

### Step 6: verify
**Date:** 2026-05-21

Verified the subscriber in the authoritative source (MongoDB), not just the
web UI front-end:

```bash
docker exec mongo mongosh open5gs --quiet --eval \
  'db.subscribers.find({ imsi: "001010000000001" }, \
   { imsi:1, "security.k":1, "security.opc":1, "security.op":1, \
     "slice.sst":1, "slice.session.name":1, _id:0 }).pretty()'
```

Output confirmed: k correct, op=null, opc set (correct USIM type),
sst=1, session name "internet". The op=null with opc populated is the proof
that the USIM type is right.

**Phase 1 deployment complete.** A working, verified 5G SA core with the
radio-facing NGAP listener up and one provisioned subscriber, ready for the
OAI gNB and UE in Phase 2.

---

## Phase 2: OAI gNB + UE over GEO NTN (RFsimulator)

**Goal:** Stand up an end-to-end 5G NR NTN radio link — OAI gNB and UE with the
GEO satellite scenario emulated in RFsimulator — and attach it to the Phase 1
Open5GS core. Validate Release-17 NTN behaviour: SIB19 broadcast/decode,
K_offset and ephemeris-based timing advance, and the random-access call flow
over the ~477 ms GEO round-trip delay.

### Step 0: OAI version + NTN config patch
**Date:** 2026-05-21

OAI checked out at tag `2026.w16` (commit `38dc378224`, 2026-04-17) — this is
the version the ngkore NTN GEO patch is tested against. The patch
(`patch_files/ntn-geo.patch` from https://github.com/ngkore/OAI-5G-NR-NTN,
renamed from OAI_NTN_RFSim) applied cleanly with `git apply`. It provides the
Release-17 NTN GEO config: SIB19, cellSpecificKoffset_r17 = 478, ephemeris-based
TA, extended RRC timers. Native NTN configs also ship in this OAI tag under
`ci-scripts/conf_files/` (GEO and LEO variants).

### Step 1: reconcile gNB/UE config to our core
Edits from the stock NTN config so the gNB attaches to our Phase 1 core
(tracked copies in `configs/oai-gnb/` and `configs/oai-ue/`):
- `tracking_area_code` 1 -> 7 (match core TAC)
- `snssaiList` -> single `{ sst = 1 }` (dropped sd; match core slice)
- `amf_ip_address` -> 172.22.0.10 (our AMF NGAP address)
- `GNB_IPV4_ADDRESS_FOR_NG_AMF` / `_NGU` -> 172.22.0.1/24 (host bridge to the
  docker_open5gs network)
- band 254 confirmed; `cellSpecificKoffset_r17 = 478` already set (GEO)
- UE `dnn` -> "internet" (match core DNN); IMSI/Ki/OPc match the subscriber

### Step 2: build
**Date:** 2026-05-21
```bash
conda deactivate
cd cmake_targets
./build_oai -I            # first-time deps
sudo apt install -y libforms-dev libforms-bin   # for nrscope
./build_oai -w SIMU --ninja --nrUE --gNB --build-lib nrscope -C
```
Build system is Ninja. Incremental rebuilds of a single target:
`ninja <target>` from `cmake_targets/ran_build/build/`. Binaries:
`ran_build/build/nr-softmodem` (gNB), `nr-uesoftmodem` (UE).

### Step 3: RFsimulator patches for GEO delay
**Date:** 2026-05-21

Two hardcoded RFsimulator limits, never hit by terrestrial (~0 delay) but
tripped by the GEO 477 ms round trip. Both captured in `patches/oai-2026.w16/`
with full rationale headers, and pinned in `external/VERSIONS.md`.

1. **Antenna-header race** (`radio/rfsimulator/simulator.cpp`,
   `process_recv_header`): the first sample-block header can arrive before
   `th.nbAnt` is populated under the long delay; stock code hard-aborts via
   `AssertFatal`, killing the gNB the moment the UE connects. Fix: treat a
   zero-antenna header as a transient (log + return); downstream code already
   tolerates it. Rebuild: `ninja rfsimulator`.

2. **Writer-queue overflow** (`radio/COMMON/common_lib.h`): the NTN UE applies
   a timing advance of ~3.6M samples for GEO, enqueuing far more pending write
   buffers than the fixed `WRITE_QUEUE_SZ` of 20, tripping `(i < 20)` in
   `writerEnqueue()` and crashing the UE. Fix: raise to 1000. Rebuild:
   `ninja rfsimulator nr-uesoftmodem nr-softmodem`.

### Step 4: run
Core up first (Phase 1), then gNB (RFsim server), then UE (client).
```bash
# gNB (terminal 2)
cd cmake_targets
sudo RFSIMULATOR=server ./ran_build/build/nr-softmodem \
  -O ../ci-scripts/conf_files/gnb.sa.band254.u0.25prb.rfsim.ntn.conf \
  --rfsim --rfsimulator.[0].prop_delay 238.74 \
  --gNBs.[0].min_rxtxtime 6 2>&1 | tee /tmp/gnb.log

# UE (terminal 3, after gNB shows "Running as server ...")
sudo RFSIMULATOR=127.0.0.1 ./ran_build/build/nr-uesoftmodem \
  -O ../targets/PROJECTS/GENERIC-NR-5GC/CONF/ue.conf \
  --band 254 -C 2488400000 --CO -873500000 \
  -r 25 --numerology 0 --ssb 60 \
  --rfsim --rfsimulator.[0].prop_delay 238.74 2>&1 | tee /tmp/ue.log
```
Note: on tag 2026.w16 all `rfsimulator.*` options need array-indexed syntax
`--rfsimulator.[0].<opt>`. `--gNBs.[0].min_rxtxtime 6` is required (UE cannot
handle shorter RX/TX). RFsim role can be set by env var (RFSIMULATOR=server /
127.0.0.1) or the indexed serveraddr option.

### Step 5: verified behaviour
- gNB: builds, boots, `activate SIB19 at DU`, NGSetupRequest ->
  **NGSetupResponse from AMF** (N2/NGAP/SCTP link up), cell PLMN 001.01 in
  service, TAC 7, GTP-U on 172.22.0.1:2152, GEO prop delay loaded, runs as
  RFsim server and survives UE connection (after patch 1).
- UE: builds, connects, **PHY sync**, decodes PBCH -> SIB1 -> SIB2 ->
  **SIB19**, reads NTN config: **k_offset 478 ms, N_Common_TA 238.74 ms,
  timing_advance_ntn 3,667,039 samples, GEO orbital radius 42,164 km,
  Doppler 0** (correct for GEO), initiates **4-step CBRA RACH**.

### Step 6: known limitation (open)
**Date:** 2026-05-21

After both patches, the UE transmits Msg1 (PRACH preamble) but the gNB never
logs receiving it (no `RA-RNTI` / `Activating RA process` / RAR on the gNB
side), so the UE loops on `RAR reception failed`. Isolated by bottom-up log
analysis: N2 link confirmed up, downlink + SIB19 confirmed decoded, so the
failure is uplink delivery. Root-caused to the RFsimulator's uplink sample
delivery under the ~3.6M-sample timing-advance offset at tag 2026.w16 — a
limitation of the simulator's sample-timeline/replay model, not a config or
protocol issue, and not a one-line fix.

**Tester's framing:** the system under test (the NR-NTN protocol stack) is
sound through RACH initiation; the defect is in the test harness (RFsim IQ
transport at this commit). Next step: re-test on OAI `develop` (and/or a newer
weekly tag) without the local rfsim patches, to check whether upstream has
since fixed the GEO uplink-delivery path.

**Phase 2 status:** NR-NTN stack validated end-to-end through SIB19 decode and
RACH initiation against the live Open5GS core; full user-plane attach pending
resolution of the RFsim uplink-delivery limitation above.
