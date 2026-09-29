#!/usr/bin/env bash
set -euo pipefail

V="${ZIG_VERSION:-0.16.0}"
case "$(uname -m)" in
  x86_64)  A=x86_64;  SHA=70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00 ;;
  aarch64) A=aarch64; SHA=ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17 ;;
  *) echo "Arquitetura não suportada: $(uname -m)" >&2; exit 1 ;;
esac

if command -v zig >/dev/null && [ "$(zig version)" = "$V" ]; then
  echo "zig $V já instalado"; exit 0
fi

T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
curl -fL "https://ziglang.org/download/$V/zig-$A-linux-$V.tar.xz" -o "$T/zig.tar.xz"
echo "$SHA  $T/zig.tar.xz" | sha256sum -c -

sudo rm -rf /opt/zig && sudo mkdir -p /opt/zig
sudo tar -xf "$T/zig.tar.xz" -C /opt/zig --strip-components=1
sudo ln -sf /opt/zig/zig /usr/local/bin/zig

zig version