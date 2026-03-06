# filebrowser-webdav

Patch-based release repository for building upstream `filebrowser/filebrowser` with WebDAV support.

## WebDAV support in this build

- WebDAV endpoint: `/webdav`
- Feature toggle: server setting `enableWebDAV` (UI and CLI flag `--enableWebDAV`)
- Authentication: HTTP Basic Auth using existing File Browser user credentials
- WebDAV class: `DAV: 1, 2` (with in-memory lock system per user)
- CORS preflight: `OPTIONS` is handled for common WebDAV clients

Permission model follows File Browser permissions:

- Read operations (`PROPFIND`, `GET`, `HEAD`) require `Download`
- `PUT` requires `Create` for new files, `Modify` for existing files
- `MKCOL` requires `Create`
- `DELETE` requires `Delete`
- `COPY` requires both `Download` and `Create`
- `MOVE` requires `Rename`
- `LOCK`, `UNLOCK`, `PROPPATCH` require `Modify`

## How it works

- This repository stores patchsets under `patches/<upstream-tag>/`.
- CI clones upstream `filebrowser/filebrowser` at a base tag.
- Patches are applied on top of that tag.
- The patched tree is built/tested/released with the same matrix as upstream.

Release tags in this repository use:

- `vX.Y.Z-webdav.N`

Examples:

- `v2.61.2-webdav.1`

For release tags, upstream base tag is derived automatically:

- `v2.61.2-webdav.1` -> `v2.61.2`

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
