# TCP/IP stacks and virtual interfaces

`vpn.device` is a SANA-II two-unit packet bridge. **Unit 0** is opened by the
Amiga TCP/IP stack as an IPv4 point-to-point interface (PPP IPv4 packet type
`0x0021`). **Unit 1** is opened by native OpenVPN as an IPv4 TUN backend
(`0x0800`). The driver does not perform encryption.

| Stack | Interface | Notes |
| --- | --- | --- |
| MiamiDX | Typically `ptp0` | Archive contains working MiamiDX-style scripts |
| AmiTCP-NG | Typically `ptp0` | Uses `DEVS:NetInterfaces` / `AddNetInterface`; separate tested AmiTCP-NG scripts not supplied |
| Roadshow | Typically `ptp0` | Similar device-interface setup to AmiTCP-NG; not independently verified here |
| PrismNet 1.0.8 | Name defined by its `NetCtl` scripts, e.g. `vpn0` | Developer tested PrismNet configuration under WinUAE; tool not bundled |

The stack needs an initial interface activation so the OpenVPN backend can
open device unit 1. Later `--up` scripting must configure an existing interface
rather than create duplicates. The interface name is a **stack preference**;
`vpn.device` has no IP address of its own. The tunnel address is chosen by the
server/profile and applied by the stack-specific script.

For full-tunnel mode, preserve a host route to the OpenVPN server through the
**physical** gateway, then route ordinary traffic through the VPN interface.
DNS must also be adjusted and restored by the stack-specific script.

The POC6 source contains native MiamiDX default-route lookup; it was hardware
validated with `openvpn --show-gateway` but **that archive alone does not prove
that its routing automation is portable to other stacks**. AmiTCP-NG and
PrismNet integration progress refers to later work not bundled here.
