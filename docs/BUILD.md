# Build instructions

## Requirements (Linux cross-build host)

- `m68k-amigaos-gcc` (historical milestone: **6.5.0b**), make and binutils.
- AmigaOS NDK includes and separately installed **SANA-II** headers.
- For OpenVPN: **AmiSSL v5 Developer SDK**, GNU Autotools and pkg-config as
  needed by the selected configure options. Do not use native Linux OpenSSL.

SDKs and toolchain are **not distributed** here.

## 1. Build and test vpn.device (confirmed host tests)

```sh
cd src/vpn-device
make test
make SANA_INCLUDE=/path/to/sana/include all
```

Outputs are created under `src/vpn-device/build/`:

- `vpn.device`
- `AOVPN-VPNProbe`, `AOVPN-MiamiPeer` (diagnostic tools)
- `AOVPN-Diag`, `AOVPN-Trace`

The Makefile fixes `CC := m68k-amigaos-gcc` for the cross-build. Ensure the
compiler is in `PATH`. Do **not** use the mock NDK headers for a real driver.
For host unit tests, a native `gcc`, `cc` and Python 3 are sufficient.

The host tests passed on the packaging machine. A cross-build and runtime test
require a separately installed Amiga cross toolchain and real hardware or
emulation; these were not available in this packaging environment.

## 2. Build OpenVPN (source present; historical helper missing)

The supplied POC6-GW1-FIX1 tree is already patched for AmigaOS; do **not**
reapply early POC/TRACE patches included for historical reference. Its
`configure.ac` contains an AmigaOS host case and AmiSSL-specific checks.

Historical validated compiler settings from the milestone:

```sh
CC=m68k-amigaos-gcc
CPPFLAGS='-D__NO_NET_API=1 -I/path/to/sana/include'
CFLAGS='-O1 -m68020 -DTARGET_AMIGA -std=gnu99 -Werror=implicit-function-declaration -Werror=int-conversion'
AMISSL_SDK=/path/to/AmiSSL/Developer
```

The milestone README refers to a separate
`AmiOpenVPN-2.6.23-68K-NATIVE-STARTUP-HARDWARE-VALIDATED-MILESTONE/tools/build_milestone.sh`.
**That script is not included in either input archive.** Consequently there
is no verified one-command client rebuild in this release bundle.

An **untested Autotools starting point**, for developers who have configured
an AmiSSL cross-build environment, is:

```sh
cd src/openvpn-2.6.23
export CC=m68k-amigaos-gcc
export AMISSL_SDK=/path/to/AmiSSL/Developer
export SANA_INCLUDE=/path/to/sana/include
export CPPFLAGS="-D__NO_NET_API=1 -I${SANA_INCLUDE} -I${AMISSL_SDK}/include"
export CFLAGS='-O1 -m68020 -DTARGET_AMIGA -std=gnu99 -Werror=implicit-function-declaration -Werror=int-conversion'
./configure --host=m68k-unknown-amigaos --disable-lzo --disable-lz4 --disable-dco --disable-plugins --disable-pkcs11 --disable-unit-tests
make
```

**This is not a known-working build command.** The AmiSSL inline library
link environment, any required target-specific cached Autoconf probe answers,
and correct `OPENSSL_LIBS` settings depend on the original helper and SDK.
The source should be built first in a disposable directory before using the
result on an Amiga. Never replace the known-good binary with an untested build.

## Release binary provenance

`amiga/bin/openvpn` and `amiga/DEVS/vpn.device` were copied without modifying
their contents from the supplied **POC6-GW1-FIX1** archive. The independently
provided `src/vpn-device` tree is **POC2-FIX4 host-tested sources**. Matching
version labels are not proof of reproducible binary identity.
