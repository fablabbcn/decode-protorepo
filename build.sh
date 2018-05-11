#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="$DIR/build"

# Enter the directory and start the build process for service stubs.
function buildDir {
  currentDir="$1"

  pushd "$currentDir" > /dev/null

  target=$(basename $currentDir)

  if [ -f .protolangs ]; then
    echo "Building directory: '$currentDir'"

    while read lang; do
      repo="twirp-$target-$lang"
      build_dir="$BUILD_DIR/$repo"

      mkdir -p "$build_dir"

      protoc --twirp_out="./$build_dir" --go_out="./$build_dir" *.proto
    done < .protolangs
  fi

  popd > /dev/null
}

# Finds all directories and builds proto buffer definitions
function buildAll {
  echo "Building protocol buffer stubs"

  clean

  find "$DIR" -type d -not -path '*/\.*' | while read d; do
    buildDir "$d"
  done
}

# Cleans our build directories
function clean {
  echo "Cleaning build directories"

  rm -rf "$BUILD_DIR"
}

buildAll
