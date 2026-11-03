# Installation (AmigaOS 3.1)

## Files and runtime prerequisites

- A fast Amiga-compatible 68k CPU; Amiga 600 + PiStorm/Emu68 was tested.
- AmiSSL v5 runtime installed and reachable through normal AmigaOS library paths.
- Working physical Internet connection through an Amiga TCP/IP stack.
- One network interface backed by `vpn.device` **unit 0**, exposed as an IPv4
  point-to-point interface. Unit 1 belongs to AmiOpenVPN itself.

Copy `amiga/DEVS/vpn.device` into `DEVS:` and perform a **full restart**.
Set up a directory assigned as `OPENVPN:` and place `openvpn`, the provider's
profile, the selected stack's lifecycle scripts, and its trusted certificate
material there. Use the stack-specific scripts for your chosen TCP/IP stack.
Only the *MiamiDX* scripts are included in this ZIP.

A simple user-startup assign (adapt path yourself):

```text
Assign OPENVPN: Work:OpenVPN
```

## MiamiDX example

Create a MiamiDX point-to-point interface `ptp0` using `vpn.device` unit 0.
MTU 1400 is the value used in the original tests. Keep the underlying
Ethernet/USB/Wi-Fi physical interface online. Assign addresses according to
what the server offers; do not hardcode the test network.

Review `amiga/miamidx/Up.script`, `RouteUp.script`, and
`RoutePreDown.script` before use. Copy to the `OPENVPN:` directory. They
adjust live interface addresses, routing and DNS; one script installs a
MiamiIPFW UDP/53 rule. The scripts are included as historical working examples,
not as production-hardened templates: in particular, DNS state is not
comprehensively restored, and `foreign_option_1` is assumed to contain DNS.
`RouteUp.script` has an optional `RequestString` fallback that is **not bundled**
because its redistribution terms are unknown: remove or replace that fallback
before depending on it.

Start from Shell with adequate stack:

```text
Stack 262144
OPENVPN:openvpn --config OPENVPN:client.ovpn
```

The example profile has `ifconfig-noexec` and `route-noexec` because
AmigaDOS scripts rather than Unix ioctl/route commands manage networking.
If your server does not push expected parameters, adjust the scripts before
trying full-tunnel routes.

## Verify

1. Check the physical server route continues using the LAN gateway.
2. Confirm the point-to-point interface got the pushed address.
3. Ping the remote tunnel endpoint and test external reachability.
4. Inspect the new default routes and DNS configuration.
5. On shutdown, verify that routes, firewall rules, and resolver settings
   are restored (you may need manual cleanup with these legacy scripts).

Troubleshoot at `verb 3`, increasing to `verb 4` or `verb 5` when needed.
The custom `aovpn-diagnostics` directive enables additional Amiga-specific logs.
