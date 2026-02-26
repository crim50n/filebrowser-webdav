#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BASE_TAG=${1:-}

if [[ -z "$BASE_TAG" ]]; then
  BASE_TAG=$(cat "$ROOT_DIR/.upstream-default-tag")
fi

PATCH_DIR="$ROOT_DIR/patches/$BASE_TAG"
SRC_DIR="$ROOT_DIR/.upstream-src"

if [[ ! -d "$PATCH_DIR" ]]; then
  echo "patch directory does not exist: $PATCH_DIR" >&2
  exit 1
fi

echo "Preparing upstream source: $BASE_TAG"
rm -rf "$SRC_DIR"
git clone --depth 1 --branch "$BASE_TAG" "https://github.com/filebrowser/filebrowser" "$SRC_DIR"

shopt -s nullglob
patches=("$PATCH_DIR"/*.patch)
shopt -u nullglob

if [[ ${#patches[@]} -eq 0 ]]; then
  echo "no patches found in $PATCH_DIR" >&2
  exit 1
fi

for patch in "${patches[@]}"; do
  echo "Applying patch: $(basename "$patch")"
  git -C "$SRC_DIR" apply --3way "$patch"
done

echo "Syncing patched source into workspace"
rsync -a --delete \
  --exclude ".git" \
  --exclude ".github" \
  --exclude ".upstream-src" \
  --exclude "patches" \
  --exclude "scripts" \
  --exclude ".upstream-default-tag" \
  --exclude "README.md" \
  "$SRC_DIR/" "$ROOT_DIR/"

echo "Patched source ready"
