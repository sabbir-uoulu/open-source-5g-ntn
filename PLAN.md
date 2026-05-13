# Eight-Phase Roadmap

Plan for the open-source 5G NR NTN testbed. Each phase produces an artefact
that maps to a 3GPP capability or architectural concept relevant to commercial
NTN systems.

## Phase 1 — 5G Core in containers
Open5GS deployed via Docker Compose. SBA NF mesh, MongoDB for subscriber data,
WebUI provisioning. Artefact: 5GC reference architecture diagram with 3GPP TS
mapping.

## Phase 2 — gNB and UE up; GEO NTN end-to-end
OAI nr-softmodem and nr-uesoftmodem on RFsimulator, with the ngkore GEO patch
(SIB19, K_offset, extended RRC timers, T300/T301/T310/T311/T319). RACH
succeeds, NAS registration completes, PDU session established, ICMP through
oaitun_ue1.
Artefact: end-to-end NAS and RRC call flow document, NTN-annotated.

## Phase 3 — Reference architecture document (headline deliverable)
A polished, citable document — modelled on 3GPP TR style and the structure of
6G-XR D1.1 — covering: system overview, reference architecture, NFs and their
functions, interfaces and protocols, NAS/RRC procedures for NTN, deltas vs
terrestrial, deployment view, and roadmap to LEO and regenerative payloads.
Deposited on Zenodo with DOI.

## Phase 4 — SMS over NAS (SMSoNAS) over NTN
Open5GS SMSF, AMF SMSoNAS configuration, demonstration of SMS delivered to
the UE via NAS signalling over a GEO NTN link with measured latency.
Artefact: SMSoNAS call flow with timing measurements.

## Phase 5 — Transport options for D2D
Comparative implementation: IP PDU, Non-IP PDU, SMSoNAS. Where each fits in
the D2D design space.
Artefact: protocol-stack comparison piece with worked examples.

## Phase 6 — Voice over NTN reality check
Analysis: VoLTE/VoNR call flows mapped against the NTN delay budget
(ITU-T G.114). Why messaging-first dominates today; what regenerative
payloads change. Written, no IMS build.

## Phase 7 — NTN-terrestrial roaming architecture
Inbound and outbound roaming over satellite. HPLMN-VPLMN relationships,
home routing vs local breakout, regulatory considerations.
Artefact: roaming architecture document with call flow.

## Phase 8 — Cloud-native deployment
Open5GS migrated from Docker Compose to single-node K3s. Manifests,
CNF-style separation, comparison with vRAN production patterns.

## Phase 9 (optional) — LEO scenario primer
Written architecture piece: extending the GEO testbed to LEO. Doppler
compensation, handover, ephemeris cadence, regenerative-payload functional
split. No working LEO build.

## Phase 10 (optional) — AI-RAN integration sketch
Written piece: where AI/ML adds value in NTN, mapped to O-RAN xApp/rApp
framework. Channel prediction, link adaptation, anomaly detection, beam
selection.

## Anti-goals

Things this project explicitly does not pursue:
- Production-grade reliability or scale testing
- Real RF transmission (RFsim only, no SDR)
- Certification or regulatory compliance work
- Closed-source vendor stacks
