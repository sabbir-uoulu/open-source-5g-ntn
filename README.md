# Open-Source 5G NR Non-Terrestrial Network: Reference Architecture and Implementation

A reproducible, fully open-source testbed for 5G NR Non-Terrestrial Networks (NTN),
covering GEO and (in planned phases) LEO scenarios. Built on OpenAirInterface (OAI)
and Open5GS, with documented architecture, protocol behaviour, and deployment
patterns for direct-to-device (D2D) services.

## Status

**Phase 1 — In progress.** Open5GS 5G Core in containers.

See [`PLAN.md`](./PLAN.md) for the full eight-phase roadmap.

## Scope

This work demonstrates:

- End-to-end 5G NR NTN architecture, mapped to 3GPP Release 17 specifications
- Working RFsim-based GEO scenario with OAI gNB and OAI UE
- Containerised 5G Core (Open5GS) with full Service-Based Architecture (SBA)
- NAS and RRC call flows for NTN-specific procedures (SIB19, ephemeris-based
  Timing Advance, K_offset scheduling, extended RRC timers)
- SMS over NAS (SMSoNAS), Non-IP PDU sessions, and IMS-adjacent considerations
  for D2D messaging services
- Cloud-native deployment patterns (Docker Compose and Kubernetes)
- NTN-terrestrial roaming architecture analysis

## Author

Sabbir Ahmed — Doctoral Researcher, 6G Flagship, University of Oulu, Finland.
Previously at 5G Test Network (5GTN) Oulu, University of Oulu, where I led
6G-XR deliverable D1.1, "Requirements and Use Case Specifications"
(Horizon Europe SNS-JU, 2023), and worked on 5G/B5G testbed deployment using
open-source solutions (OpenAirInterface, srsRAN, Open5GS, free5GC, UERANSIM)
and commercial Nokia RAN.

## Licensing

- Documentation, diagrams, and configurations: CC-BY-4.0 — see [`LICENSE`](./LICENSE)
- Code, scripts, automation: MIT — see [`LICENSE-CODE`](./LICENSE-CODE)

## Attribution to third-party projects

This work integrates and depends upon:

- [OpenAirInterface 5G (OAI)](https://gitlab.eurecom.fr/oai/openairinterface5g) —
  GNU OAI Public License — EURECOM
- [Open5GS](https://open5gs.org/) — AGPL-3.0 — Sukchan Lee and contributors
- [docker_open5gs](https://github.com/herlesupreeth/docker_open5gs) — BSD — Supreeth Herle
- [OAI NTN patches](https://github.com/ngkore/OAI_NTN_RFSim) — community contributions, ngkore

Pinned versions and commits in [`external/VERSIONS.md`](./external/VERSIONS.md).

## Citation

If you use this work, please cite it. Citation metadata will be added once
the Phase 3 architecture document is deposited on Zenodo (planned).

## Contact

[Update with professional email and links when GitHub account is live.]
