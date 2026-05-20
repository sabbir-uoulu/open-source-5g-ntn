# Open-Source 5G NR Non-Terrestrial Network: Reference Architecture and Implementation

A reproducible, fully open-source testbed for 5G NR Non-Terrestrial Networks (NTN),
covering GEO and (in planned phases) LEO scenarios. Built on OpenAirInterface (OAI)
and Open5GS, with documented architecture, protocol behaviour, and deployment
patterns for direct-to-device (D2D) services.

## Scope and goals

- **Build a working, end-to-end 5G NR NTN testbed using only open-source components** — Open5GS for the 5G Core, OpenAirInterface for gNB and UE — with a GEO satellite link emulated in RFsimulator. Single-host, fully reproducible, every dependency pinned by commit. A LEO scenario primer is added as a written extension; no working LEO build is in scope.

- **Demonstrate 3GPP Release-17 NTN protocol behaviour with measurable evidence** — SIB19 ephemeris delivery, K_offset scheduling, ephemeris-based Timing Advance, extended RRC timers, NAS registration and PDU session establishment over an emulated 477 ms round-trip GEO link. Captured in call-flow documents and log evidence, not just claims.

- **Cover commercially relevant direct-to-device (D2D) transport modes** — IP PDU sessions, Non-IP PDU sessions, and SMS over NAS (SMSoNAS), each demonstrated end-to-end. These are the transport options that determine how messaging-first D2D services carry payload.

- **Produce a citable, publishable reference architecture document** — modelled on 3GPP TR style: system overview, reference architecture, network functions, interfaces and protocols, NAS/RRC procedures for NTN, deployment view (Docker Compose and Kubernetes), NTN-terrestrial roaming, a voice-over-NTN analysis, and a roadmap to LEO and AI-RAN. Deposited on Zenodo with a DOI; source on GitHub under CC-BY-4.0.

- **Treat reproducibility and provenance as first-class concerns** — every third-party dependency is cloned into a gitignored `external/` directory and pinned by commit hash in `external/VERSIONS.md`; every configuration change is layered separately from upstream so the diff is always visible; every command, design choice, and rationale is recorded in `lab-notes.md`.

### Explicit non-goals

- Real radio transmission (RFsim only; no SDR despite a USRP B210 being available)
- Production-grade reliability, performance, or scale testing
- Certification or regulatory compliance work
- Closed-source vendor stacks or commercial test equipment
- LEO operation as a working build (analysed as a written extension only)

## Status

**Phase 1 — In progress.** Open5GS 5G Core in containers.

See [`PLAN.md`](./PLAN.md) for the full eight-phase roadmap.

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
