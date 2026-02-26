# filebrowser-webdav

Patch-based release repository for building upstream `filebrowser/filebrowser` with WebDAV support.

## How it works

- This repository stores patchsets under `patches/<upstream-tag>/`.
- CI clones upstream `filebrowser/filebrowser` at a base tag.
- Patches are applied on top of that tag.
- The patched tree is built/tested/released with the same matrix as upstream.

Release tags in this repository use:

- `vX.Y.Z-webdav.N`

Examples:

- `v2.60.0-webdav.1`

For release tags, upstream base tag is derived automatically:

- `v2.60.0-webdav.1` -> `v2.60.0`

For branch/PR CI runs, base tag comes from `.upstream-default-tag`.

## Publishing targets

- GitHub Releases in `crim50n/filebrowser-webdav` (binary archives)
- Container images in `ghcr.io/crim50n/filebrowser-webdav`

## Updating to a new upstream release

1. Create `patches/vX.Y.Z/`.
2. Add patch files in order (e.g. `0001-*.patch`, `0002-*.patch`).
3. Update `.upstream-default-tag` if desired.
4. Push and verify CI.
5. Create release tag `vX.Y.Z-webdav.1`.
