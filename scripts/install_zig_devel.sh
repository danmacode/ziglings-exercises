#!/bin/env bash
#
# Script to install the latest Zig development version in /opt/zig-devel
# and symlink it to ~/.local/bin/zig

set -euo pipefail

# Get the latest Zig release JSON
json_url="https://ziglang.org/download/index.json"
json=$(curl -s "$json_url")

# Extract the x86_64-linux tarball URL from the "master" release
url=$(echo "$json" | jq -r '.master."x86_64-linux".tarball')

installed_version=$(zig version 2>/dev/null) || installed_version=$(zig-devel version 2>/dev/null)
if echo "$url" | grep -q "$installed_version"; then
	echo "Installed Zig version ($installed_version) matches the latest URL."
	exit 0
fi

# Download and extract the tarball to /opt/zig-devel
sudo mkdir -p /opt/zig-devel
curl -sL "$url" | sudo tar -xJ --strip-components=1 -C /opt/zig-devel

# Symlink /opt/zig-devel/zig to /usr/.local/bin/zig-devel
mkdir -p ~/.local/bin
sudo ln -sf /opt/zig-devel/zig ~/.local/bin/zig
