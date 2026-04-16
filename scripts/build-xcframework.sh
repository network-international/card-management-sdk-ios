#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$REPO_ROOT/release}"
ARCHIVE_DIR="${ARCHIVE_DIR:-$REPO_ROOT/archives}"
PROJECT="${PROJECT:-$REPO_ROOT/CardManagementSDK.xcodeproj}"
SCHEME="${SCHEME:-NICardManagementSDK}"
FRAMEWORK_NAME="NICardManagementSDK.framework"
VERSION="${VERSION:-$(git describe --tags --abbrev=0 2>/dev/null || echo "")}"

if [ -z "$VERSION" ]; then
  echo "Error: VERSION is not set or could not be determined from git tags." >&2
  echo "Set VERSION explicitly when calling the script or run this script from a tagged commit." >&2
  echo "Example: VERSION=9.9.9 ./scripts/build-xcframework.sh" >&2
  exit 1
fi

mkdir -p "$ARCHIVE_DIR" "$OUTPUT_DIR"
rm -rf "$ARCHIVE_DIR/iOS.xcarchive" "$ARCHIVE_DIR/Simulator.xcarchive" "$OUTPUT_DIR/NICardManagementSDK.xcframework"

xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_DIR/iOS.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$ARCHIVE_DIR/Simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

IOS_DSYM_PATH="$(find "$ARCHIVE_DIR/iOS.xcarchive" -name "${FRAMEWORK_NAME}.dSYM" -print -quit)"
SIM_DSYM_PATH="$(find "$ARCHIVE_DIR/Simulator.xcarchive" -name "${FRAMEWORK_NAME}.dSYM" -print -quit)"

if [ -z "$IOS_DSYM_PATH" ] || [ -z "$SIM_DSYM_PATH" ]; then
  echo "Error: dSYM bundle not found in archive output." >&2
  exit 1
fi

xcodebuild -create-xcframework \
  -framework "$ARCHIVE_DIR/iOS.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -debug-symbols "$IOS_DSYM_PATH" \
  -framework "$ARCHIVE_DIR/Simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -debug-symbols "$SIM_DSYM_PATH" \
  -output "$OUTPUT_DIR/NICardManagementSDK.xcframework"

ZIPFILE="$OUTPUT_DIR/NICardManagementSDK-${VERSION}.zip"
rm -f "$ZIPFILE"
cd "$OUTPUT_DIR"
zip -r "$ZIPFILE" "NICardManagementSDK.xcframework"

echo "Built XCFramework package: $ZIPFILE"
