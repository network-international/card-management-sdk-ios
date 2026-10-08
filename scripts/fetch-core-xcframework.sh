#!/usr/bin/env bash
# Download Core XCFramework into Vendor/ for CocoaPods Example (and local pod :path).
# Prefers `gh`; falls back to curl + CORE_GITHUB_TOKEN for private release assets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_VERSION="${CORE_VERSION:-0.1.0}"
CORE_REPO="${CORE_REPO:-akiselevn/card-management-sdk-core}"
CORE_TAG="${CORE_TAG:-core-${CORE_VERSION}}"
ASSET_NAME="NICardManagementSDKCore.xcframework.zip"
DEST_DIR="${ROOT}/Vendor"
DEST_XCF="${DEST_DIR}/NICardManagementSDKCore.xcframework"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p "${DEST_DIR}"

download_with_gh() {
  command -v gh >/dev/null 2>&1 || return 1
  gh release download "${CORE_TAG}" -R "${CORE_REPO}" \
    --pattern "${ASSET_NAME}" \
    --dir "${TMP_DIR}"
}

download_with_curl() {
  if [[ -z "${CORE_GITHUB_TOKEN:-}" ]]; then
    echo "error: set CORE_GITHUB_TOKEN (or use authenticated gh) to download ${CORE_REPO}@${CORE_TAG}." >&2
    return 1
  fi
  local api="https://api.github.com/repos/${CORE_REPO}/releases/tags/${CORE_TAG}"
  local url
  url="$(curl -fsSL -H "Authorization: Bearer ${CORE_GITHUB_TOKEN}" -H "Accept: application/vnd.github+json" "${api}" \
    | python3 -c "import json,sys; assets=json.load(sys.stdin).get('assets',[]); print(next(a['url'] for a in assets if a['name']=='${ASSET_NAME}'))")"
  curl -fsSL -H "Authorization: Bearer ${CORE_GITHUB_TOKEN}" -H "Accept: application/octet-stream" \
    "${url}" -o "${TMP_DIR}/${ASSET_NAME}"
}

echo "Fetching ${CORE_REPO} ${CORE_TAG} → ${DEST_XCF}"
if ! download_with_gh; then
  download_with_curl
fi

rm -rf "${DEST_XCF}"
unzip -q "${TMP_DIR}/${ASSET_NAME}" -d "${TMP_DIR}/unzipped"
if [[ -d "${TMP_DIR}/unzipped/NICardManagementSDKCore.xcframework" ]]; then
  mv "${TMP_DIR}/unzipped/NICardManagementSDKCore.xcframework" "${DEST_XCF}"
else
  # zip rooted at xcframework contents
  mkdir -p "${DEST_XCF}"
  mv "${TMP_DIR}/unzipped/"* "${DEST_XCF}/"
fi

if [[ ! -f "${DEST_XCF}/Info.plist" ]]; then
  echo "error: expected Info.plist under ${DEST_XCF}" >&2
  exit 1
fi

echo "Ready: ${DEST_XCF}"
