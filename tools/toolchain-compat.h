/* Force-included by tools/build-m68k.sh for the AmigaDev GCC 16.2 toolchain.
 * Its newlib sys/select.h must come before the NDK sys/socket.h, and its
 * headers lack struct sockaddr_storage (only manage.c uses it). */
#include <sys/types.h>
#include <sys/socket.h>
#ifndef _SS_MAXSIZE
struct sockaddr_storage {
    unsigned char ss_len;
    unsigned char ss_family;
    char ss_pad[126];
};
#endif
