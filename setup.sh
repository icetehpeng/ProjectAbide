#!/bin/bash
set -e

echo "Checking for XcodeGen..."
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
    brew install xcodegen
fi

echo "Generating Xcode project..."
xcodegen generate

echo "ProjectAbide setup complete!"
echo "Open ProjectAbide.xcodeproj to start developing."