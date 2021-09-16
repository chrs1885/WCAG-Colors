#!/bin/sh
# Run this script from the root directory just before starting to contribute code.

#================================= Tooling =================================
echo "Installing tools (SwiftLint, SwiftFormat, and SourceDocs"
cd BuildTools
swift build

echo "Installing pre-commit hook"
swift run komondor install
