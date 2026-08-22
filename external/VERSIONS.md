# External Dependencies (Pinned Versions)

This project integrates several third-party open-source projects. Each is
cloned into `external/` (gitignored, not redistributed here). The exact
versions used are recorded below for reproducibility.

To reproduce, clone each project at the specified commit.

## docker_open5gs

- Source: https://github.com/herlesupreeth/docker_open5gs
- Commit: `7722ae2eba474f50e0255fde731d0785689e37a2` (2026-04-10)
- Licence: BSD
- Used for: Open5GS 5G Core container orchestration in Phase 1.
- Pre-built images pulled from ghcr.io (Phase 1, 2026-05-21):
  - `docker_open5gs:master` digest `sha256:68247a557ae8e2a46beca39bceb06d63d0c3daebb9f6b95312be9384461154c1`
  - `docker_grafana:master` digest `sha256:a202291d069eb8274ff3f27cf99946fad8c9b239ad4378057ba789a96730468e`
  - `docker_metrics` built locally (no pre-built image); bundles Prometheus 3.5.0
  - Open5GS version baked into the image: v2.7.6-131-g782a97e
  - Base images: mongo:6.0, grafana/grafana:11.3.0

## openairinterface5g

- Source: https://gitlab.eurecom.fr/oai/openairinterface5g
- Tag: `2026.w16`
- Commit: `38dc378224d230a50a787f3d8e7d460314fcf770` (2026-04-17)
- Licence: GNU OAI Public License
- Used for: gNB (nr-softmodem) and UE (nr-uesoftmodem) in Phase 2.
- Build: `./build_oai -w SIMU --ninja --nrUE --gNB --build-lib nrscope -C`
- Local patches applied (see `patches/oai-2026.w16/`):
  - `01-rfsim-antenna-assertion.patch`, tolerate zero-antenna RFsim
    header under NTN long delay (radio/rfsimulator/simulator.cpp)
  - `02-rfsim-write-queue-size.patch`, raise WRITE_QUEUE_SZ 20->1000
    for the GEO timing advance (radio/COMMON/common_lib.h)
  - `03-ntn-rar-window-koffset.patch`, make the Msg2/RAR
    response window NTN-aware by adding cell-specific K_offset
    (openair2/LAYER2/NR_MAC_gNB/gNB_scheduler_RA.c). Enables RACH
    completion over the GEO round trip. Terrestrial unaffected.
- Runtime requirement (GEO): both gNB and UE must run with real-time thread
  scheduling (`sudo chrt -f 80 env ..`) and CPU governor `performance`, else the
  rfsimulator lock-step diverges (cf. OAI issue #829). prop_delay is set in the
  conf files, not the command line.
- Our configs (tracked, applied per Pattern-Y at deploy time):
  - `configs/oai-gnb/gnb.sa.band254.u0.25prb.rfsim.ntn.conf`
  - `configs/oai-ue/ue.conf`

## OAI NTN GEO patch

- Source: https://github.com/ngkore/OAI-5G-NR-NTN  (renamed from OAI_NTN_RFSim)
- Patch: `patch_files/ntn-geo.patch`, tested upstream vs OAI tag 2026.w16
- Licence: see upstream
- Used for: Release-17 NTN behaviour (SIB19, K_offset, RRC timer extension)
  in Phase 2.

## Open5GS WebUI

Bundled with docker_open5gs; not separately pinned.
