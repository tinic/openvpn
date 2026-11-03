# AmiOpenVPN 2.6.23 for AmigaOS 68k

Native IPv4 OpenVPN client using **AmiSSL v5**, an Amiga TCP/IP stack's
`bsdsocket.library`, and the SANA-II `vpn.device`. OpenVPN's TLS and traffic
encryption run on AmigaOS, not on the PiStorm host processor.

This ZIP is a **single-source-and-binary distribution** assembled from two
supplied milestone archives. It contains the OpenVPN 2.6.23 Amiga port source,
the `vpn.device` source and host tests, prebuilt Amiga binaries, and setup notes.

## Contents

| Path | Contents |
| --- | --- |
| `src/openvpn-2.6.23/` | Modified OpenVPN 2.6.23 source (POC6-GW1-FIX1, 27 Oct 2026) |
| `src/vpn-device/` | SANA-II vpn.device POC2-FIX4 source, Makefile, tests and BSD notices |
| `amiga/bin/openvpn` | Prebuilt m68k OpenVPN executable from supplied POC6 archive |
| `amiga/DEVS/vpn.device` | Prebuilt driver from supplied POC6 archive |
| `amiga/miamidx/` | Original MiamiDX lifecycle scripts and helpers |
| `amiga/examples/client.ovpn.example` | Sanitized starter configuration (no credentials) |
| `docs/` | Build, installation, stack integration, release notes and security guidance |

## Supported configurations

The **client** uses standard Amiga `bsdsocket.library` and is not tied to
MiamiDX. Network interface, routes and DNS are managed by stack-specific scripts.

| Stack | Known state | Included integration |
| --- | --- | --- |
| **MiamiDX** | Hardware-validated in the POC6 milestone | Original MiamiDX scripts supplied |
| **AmiTCP-NG** | Independently hardware-validated in later work | **Not included** in these two milestone archives |
| **Roadshow** | Intended to work similarly to AmiTCP-NG; full validation pending | **Not included** |
| **PrismNet 1.0.8** | Tested by its developer under WinUAE with NetCtl | **Not included** |

Do **not** run the MiamiDX scripts unchanged on other TCP/IP stacks.

## Quick start (MiamiDX)

1. Install **AmiSSL v5** and a functioning IPv4 TCP/IP stack.
2. Copy `amiga/DEVS/vpn.device` to `DEVS:vpn.device`, then reboot so the
   new resident driver is loaded.
3. Copy `amiga/bin/openvpn`, the three scripts from `amiga/miamidx/`,
   to one Amiga directory.
   Assign this directory as `OPENVPN:`.
4. In MiamiDX configure a point-to-point interface such as `ptp0` using
   **vpn.device unit 0**, MTU 1400. Keep your regular LAN/WAN interface up.
5. Make a working `.ovpn` file from `amiga/examples/client.ovpn.example`.
   Supply your own server address, CA, credentials and optional client cert/key
   and `tls-crypt` material. Review every networking command in the scripts.
6. From an AmigaDOS Shell, once `ptp0` is available:

   ```text
   Stack 262144
   OPENVPN:openvpn --config OPENVPN:client.ovpn
   ```

The server assigns the tunnel addresses; `10.77.0.1/10.77.0.2` belonged to a
historical test, **not** to all OpenVPN connections. The included older MiamiDX
scripts have assumptions about pushed DNS and routing that must be reviewed.

See [Installation](docs/INSTALL.md) and [TCP/IP stack notes](docs/STACKS.md).

## How the virtual interface works

- **vpn.device unit 0:** point-to-point SANA-II interface for the Amiga TCP/IP
  stack (`ptp0`, or another stack-specific name), PPP IPv4 packet type `0x0021`.
- **vpn.device unit 1:** opened by AmiOpenVPN as its TUN backend; raw IPv4
  packets use protocol type `0x0800`.
- The device itself **does not encrypt**. Encryption is handled by the
  native OpenVPN process using AmiSSL.

## Build

- **Driver:** reproducible commands and host-test instructions are in
  [docs/BUILD.md](docs/BUILD.md). The bundled driver host tests passed during
  this ZIP's assembly.
- **Client:** the complete milestone source is present, but the original
  build wrapper (`tools/build_milestone.sh` from an older milestone) is **not**
  present in the supplied archive. The historical compiler settings and an
  unverified Autotools starting point are documented in `docs/BUILD.md`.
  A fresh client cross-build was **not** performed for this release ZIP.

## Scope / limitations

Validated mode: **UDP, IPv4 TUN**, TLS/certificate authentication and AES-GCM.
No claim is made for IPv6 tunnels, TAP bridging, DCO, unattended reconnection
or universal DNS leak protection. Historical data points do not constitute a
security audit. Keep VPN private keys private and never commit `.ovpn` profiles
containing credentials.

A Certificate Signing Request (**CSR**) was also generated locally on AmigaOS
in later project testing, so the associated private key can remain on the Amiga.
The CSR-generation utility is **not** among the supplied archive contents.

## Licenses and provenance

See [docs/LICENSES.md](docs/LICENSES.md) and
[docs/RELEASE-NOTES.md](docs/RELEASE-NOTES.md). The modified OpenVPN tree keeps
its upstream `COPYING` and copyright notices (GPLv2 and documented exceptions).
The `vpn.device` tree retains its BSD-2-Clause third-party notices.

**Important:** `amiga/` contains prebuilt artifacts from one milestone, and
`src/vpn-device/` comes from a separately supplied source milestone. Their
bit-for-bit binary/source correspondence has **not** been independently proven.
