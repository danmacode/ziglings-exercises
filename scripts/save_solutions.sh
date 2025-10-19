#!/bin/env bash
#
# Script to save git-staged solutions as patch files in the solutions/ directory

set -euo pipefail

# Move to parent dir of the script (repo root)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/.." || exit 1

# Read progress limit
progress=$(cat .progress.txt)
echo "Progress limit: $progress"

# Ensure solutions/ exists
mkdir -p solutions

# Loop through staged zig files
for f in $(git diff --cached --name-only -- 'exercises/*.zig'); do
	# Extract the filename (e.g., 07-thing.zig)
	filename=$(basename "$f")

	patchfile="solutions/${filename%.zig}.patch"
	git diff --cached "$f" >"$patchfile"
	echo "Saved patch for $f -> $patchfile"
done
