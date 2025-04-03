#!/bin/sh

set -euo pipefail

# Sends a git patch via email
# Usage: ./email-my-commit.sh <recipient> <revision-range>

RECIPIENT=${1:-moio@suse.com}
REVISION_RANGE=${2:-HEAD~}

git send-email --smtp-debug --to "$RECIPIENT" "$REVISION_RANGE"

echo "Patch sent successfully to $RECIPIENT"

exit 0
