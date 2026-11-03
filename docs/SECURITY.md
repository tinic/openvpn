# Security and release checklist

- **Do not publish** private `.key` files, real credentialed `.ovpn` profiles,
  full user TCP/IP configuration databases, tokens, personal certificates or
  environment variables containing secrets.
- Obtain the current AmiSSL runtime and verify publisher authenticity.
- Verify remote server certificates (`remote-cert-tls server` and trusted CA).
- Review stack-specific route and DNS scripts before first use, especially
  firewall rules and cleanup paths after an abnormal exit.
- The sample only documents IPv4/UDP use; this is not a full security audit
  and does not guarantee leak prevention for every resolver/protocol.
- Do not expose the Amiga's management ports or unprotected services directly
  to the public Internet.
- When publishing to GitHub, also review **commit history** and release assets:
  deleting a secret from a later commit does not remove it from earlier ones.
