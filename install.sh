#!/bin/bash

set -e

echo "Installing thuthesis-compiler..."
echo ""

MARKETPLACE_PATH="$(cd "$(dirname "$0")/.." && pwd)"
echo "Marketplace path: $MARKETPLACE_PATH"

claude plugin marketplace add "$MARKETPLACE_PATH" 2>/dev/null || true

echo "Installing thuthesis-compiler..."
claude plugin install thuthesis-compiler

echo ""
echo "thuthesis-compiler installed successfully!"
echo ""
echo "Usage: /thuthesis-compiler:compile"
echo ""
