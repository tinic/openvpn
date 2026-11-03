#!/bin/sh
# Cross-build vpn.device and openvpn out of tree.
# usage: tools/build-m68k.sh <toolchain prefix> <AmiSSL Developer dir> <build dir>
set -e
TC=$1; SSL=$2; OUT=$3
[ -x "$TC/bin/m68k-amigaos-gcc" ] && [ -d "$SSL/include" ] && [ -n "$OUT" ] || {
    echo "usage: $0 <toolchain prefix> <AmiSSL Developer dir> <build dir>" >&2; exit 2; }
SRC=$(cd "$(dirname "$0")/.." && pwd)
PATH=$TC/bin:$PATH; export PATH
mkdir -p "$OUT/vpn-device" "$OUT/openvpn"
OUT=$(cd "$OUT" && pwd)

m68k-amigaos-gcc -include dos/dos.h -nostdlib -nostartfiles -O1 -Wall -Wextra -Werror \
    -Wno-unused-parameter -fomit-frame-pointer -m68000 -msoft-float \
    -o "$OUT/vpn-device/vpn.device" "$SRC/src/vpn-device/src/vpn_device.c"

# The zip loses timestamps; keep make from rerunning autotools.
O=$SRC/src/openvpn-2.6.23
touch "$O/aclocal.m4"; touch "$O/configure" "$O/config.h.in"
find "$O" -name Makefile.in -exec touch {} +
cd "$OUT/openvpn"
sh "$O/configure" --host=m68k-unknown-amigaos \
    --disable-lzo --disable-lz4 --disable-dco --disable-plugins \
    --disable-pkcs11 --disable-unit-tests \
    CC=m68k-amigaos-gcc AR=m68k-amigaos-ar RANLIB=m68k-amigaos-ranlib \
    ROUTE=/sbin/route IFCONFIG=/sbin/ifconfig \
    CPPFLAGS="-D__NO_NET_API=1 -I$SSL/include" \
    CFLAGS="-O1 -m68020 -DTARGET_AMIGA -std=gnu99 -Werror=implicit-function-declaration -Werror=int-conversion" \
    OPENSSL_CFLAGS="-I$SSL/include" OPENSSL_LIBS="-L$SSL/lib/AmigaOS3 -lamisslstubs" \
    >configure.log 2>&1 || { tail -20 configure.log; exit 1; }
# The shim goes in at make time only; configure probes break with it.
make -C src -j"${JOBS:-4}" CPPFLAGS="-include $SRC/tools/toolchain-compat.h -D__NO_NET_API=1 -I$SSL/include" >make.log 2>&1 || { grep -E "error:|undefined reference" make.log | head -20; exit 1; }
ls -l "$OUT/vpn-device/vpn.device" "$OUT/openvpn/src/openvpn/openvpn"
