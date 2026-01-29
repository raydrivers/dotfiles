#!/bin/bash
set -e
version="0.18.2"
case "$(uname -s)-$(uname -m)" in
    Darwin-arm64)  arch="aarch64-apple-darwin" ;;
    Darwin-x86_64) arch="x86_64-apple-darwin" ;;
    Linux-x86_64)  arch="x86_64-unknown-linux-gnu" ;;
    *) echo "Unsupported platform"; exit 1 ;;
esac
tmp=$(mktemp -d)
curl -sL "https://github.com/dandavison/delta/releases/download/${version}/delta-${version}-${arch}.tar.gz" | tar xz -C "$tmp"
sudo mv "$tmp/delta-${version}-${arch}/delta" /usr/local/bin/
rm -rf "$tmp"
echo "delta installed"
