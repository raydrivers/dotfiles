#!/bin/bash
set -e
version="0.18.2"
case "$(uname -s)-$(uname -m)" in
    Darwin-arm64)       arch="aarch64-apple-darwin" ;;
    Darwin-x86_64)      arch="x86_64-apple-darwin" ;;
    Linux-x86_64)       arch="x86_64-unknown-linux-gnu" ;;
    MINGW64*-x86_64|MSYS*-x86_64) arch="x86_64-pc-windows-msvc" ;;
    *) echo "Unsupported platform: $(uname -s)-$(uname -m)"; exit 1 ;;
esac

tmp=$(mktemp -d)

if [[ "$arch" == *windows* ]]; then
    curl -sL "https://github.com/dandavison/delta/releases/download/${version}/delta-${version}-${arch}.zip" -o "$tmp/delta.zip"
    unzip -q "$tmp/delta.zip" -d "$tmp"
    mkdir -p "$HOME/.local/bin"
    mv "$tmp/delta-${version}-${arch}/delta.exe" "$HOME/.local/bin/"
else
    curl -sL "https://github.com/dandavison/delta/releases/download/${version}/delta-${version}-${arch}.tar.gz" | tar xz -C "$tmp"
    sudo mv "$tmp/delta-${version}-${arch}/delta" /usr/local/bin/
fi

rm -rf "$tmp"
echo "delta installed"
