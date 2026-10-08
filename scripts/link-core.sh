#!/usr/bin/env bash
# Point Vendor/NICardManagementSDKCore at a local Core ios/ checkout (SPM source package).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${ROOT}/Vendor/NICardManagementSDKCore"
mkdir -p "${ROOT}/Vendor"

if [[ -n "${CORE_IOS_DIR:-}" ]]; then
  SRC="${CORE_IOS_DIR}"
else
  CANDIDATES=(
    "${ROOT}/../../card-management-sdk-core/card-management-sdk-core/ios"
    "${ROOT}/../card-management-sdk-core/card-management-sdk-core/ios"
    "${ROOT}/../card-management-sdk-core/ios"
  )
  SRC=""
  for c in "${CANDIDATES[@]}"; do
    if [[ -f "${c}/Package.swift" ]]; then
      SRC="${c}"
      break
    fi
  done
fi

if [[ -z "${SRC}" || ! -f "${SRC}/Package.swift" ]]; then
  echo "error: Core iOS package not found. Clone card-management-sdk-core and set CORE_IOS_DIR to its ios/ directory." >&2
  exit 1
fi

# Prefer a relative symlink when possible.
REL="$(python3 - "${DEST}" "${SRC}" <<'PY'
import os, sys
dest_parent = os.path.dirname(sys.argv[1])
src = os.path.abspath(sys.argv[2])
print(os.path.relpath(src, dest_parent))
PY
)"
ln -sfn "${REL}" "${DEST}"
echo "Linked ${DEST} -> ${REL}"

XCF="${SRC}/build/NICardManagementSDKCore.xcframework"
if [[ -d "${XCF}" ]]; then
  XCF_REL="$(python3 - "${ROOT}/Vendor/NICardManagementSDKCore.xcframework" "${XCF}" <<'PY'
import os, sys
dest_parent = os.path.dirname(sys.argv[1])
src = os.path.abspath(sys.argv[2])
print(os.path.relpath(src, dest_parent))
PY
)"
  ln -sfn "${XCF_REL}" "${ROOT}/Vendor/NICardManagementSDKCore.xcframework"
  echo "Linked ${ROOT}/Vendor/NICardManagementSDKCore.xcframework -> ${XCF_REL}"
else
  echo "note: Core XCFramework not built yet (optional; SPM uses Core Package.swift / binary package — run card-management-sdk-core/scripts/build-ios.sh if you need the XCFramework locally)"
fi
