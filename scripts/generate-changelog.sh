#!/bin/bash

# Check if git-cliff is installed
if ! command -v git-cliff &> /dev/null
then
    echo "git-cliff could not be found."
    echo "Please install it using one of the following methods:"
    echo "  - Cargo: cargo install git-cliff"
    echo "  - NPM: npm install -g git-cliff"
    echo "  - Homebrew: brew install git-cliff"
    exit 1
fi

# Generate changelog
echo "Generating CHANGELOG.md using git-cliff..."
git-cliff --output CHANGELOG.md

echo "Done."
