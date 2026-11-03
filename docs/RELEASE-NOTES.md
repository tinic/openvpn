# Unified bundle provenance and validation

Input archives:

1. `AmiOpenVPN-2.6.23-POC6-GW1-FIX1-HARDWARE-VALIDATED-MILESTONE(4).zip`
2. `AmiOpenVPN-VPNDEVICE-POC2-FIX4-REAL-RX-ONEVENT-HOST-TESTED-SOURCES(4).zip`

Combined without modifying source code or executable bytes. Main original
OpenVPN milestone: **27 October 2026**, validated physical default-gateway
lookup with MiamiDX. Its own milestone notes specify that dynamic full-tunnel
routing was not yet validated *at that specific milestone*.

The driver sources are labeled POC2-FIX4 host-tested in their original README.
Later successful Amiga hardware tests are known from the project, but the
attached driver archive itself does not carry that updated statement. Binary
and standalone driver source correspondences were not independently checked.

The complete integration of later AmiTCP-NG DNS restoration, Roadshow scripts,
and PrismNet `NetCtl` is **not included** in these inputs. No claims of a newly
hardware-validated merged release are made.

Packaging adjustments:

- Converted two nested archives into one navigable source layout.
- Retained upstream license files and source comments.
- Omitted upstream demonstration sample private keys (`sample/sample-keys/`).
- Omitted the supplied user-specific binary MiamiDX profile (`3com.miami`),
  which contains local IP/DNS configuration and password hashes.
- Omitted local LAN-specific `user-startup.txt` and the obsolete sample
  `.ovpn` that contained an AWS lab endpoint; added neutral examples instead.
- Omitted optional `usbnethttp` benchmark executable and Ami `.info` icon.
- Omitted the `RequestString` binary because its source/license was not in the inputs;
  the historical `RouteUp.script` references it only if gateway discovery fails.
  Obtain it separately with redistribution rights or replace that fallback.
- Excluded build outputs and old editor backup files from the source trees.
- Renamed the upstream `.gitignore` to `UPSTREAM.gitignore.txt` so its generated
  Autotools files (e.g. `configure`, `Makefile.in`) can be committed intact.
- Included two original scripts for startup/shutdown as `.original` because
  they reference archive-specific configuration names and need adapting.

A fresh OpenVPN cross-build, VPN connection, and long-running tunnel test were
**not performed during packaging**. Host-side driver tests passed.
