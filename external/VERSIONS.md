# External Dependencies — Pinned Versions

This project integrates several third-party open-source projects. Each is
cloned into `external/` (gitignored — not redistributed here). The exact
versions used are recorded below for reproducibility.

To reproduce, clone each project at the specified commit.

## docker_open5gs
- Source: https://github.com/herlesupreeth/docker_open5gs
- Commit: TBD (to be filled in Step 2 of Phase 1)
- Licence: BSD
- Used for: Open5GS 5G Core container orchestration in Phase 1.

## openairinterface5g
- Source: https://gitlab.eurecom.fr/oai/openairinterface5g
- Branch: develop
- Commit: TBD (to be filled in Phase 2)
- Licence: GNU OAI Public License
- Used for: gNB (nr-softmodem) and UE (nr-uesoftmodem) in Phase 2.

## OAI NTN GEO patch
- Source: https://github.com/ngkore/OAI_NTN_RFSim
- Commit: TBD (to be filled in Phase 2)
- Licence: see upstream
- Used for: Release-17 NTN behaviour (SIB19, K_offset, RRC timer extension)
  in Phase 2.

## Open5GS WebUI
- Bundled with docker_open5gs; not separately pinned.
