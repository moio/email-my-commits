#!/bin/sh

set -euo pipefail

# Sends a git patch via email

COMMIT=${1:-HEAD}
RECIPIENT=${2:-moio@suse.com}

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Send a git patch via email.

Options:
  -c COMMIT_ID   Specify the git commit ID (default: ${COMMIT})
  -r RECIPIENT   Specify the recipient email address (default: ${RECIPIENT})
  -h             Display this help message

EOF
  exit "$1"
}

# Function to get the patch text from git.
get_patch() {
  local commit_id="$1"

  # Check if git is available.
  if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed or not in PATH." >&2
    return 1
  fi

  # Check if we are in a git repository
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo "Error: not a git repository" >&2
      return 1
  fi

  # Get the patch.
  git format-patch -1 --stdout "$commit_id"
}

# Function to send the patch via email.
send_email() {
  local recipient="$1"
  local patch_text="$2"
  local subject=""
  
  # Get subject from the first line of the commit message
  subject=$(echo "$patch_text" | head -n 1 | sed 's/^From .* //')

  # Check if mail is available.
  if ! command -v mail >/dev/null 2>&1; then
      echo "Error: mail is not installed or not in PATH" >&2
      return 1
  fi
  
  # send email using mail
  echo "$patch_text" | mail -s "$subject" "$recipient"
}

# --- Main ---

# Set default values.
commit_id="${COMMIT}"
recipient="${RECIPIENT}"

# Parse command-line options.
while getopts "c:r:h" opt; do
  case "$opt" in
    c)
      commit_id="$OPTARG"
      ;;
    r)
      recipient="$OPTARG"
      ;;
    h)
      usage 0
      ;;
    *)
      usage 1
      ;;
  esac
done
shift "$((OPTIND - 1))"
if [ "$#" -gt 0 ]; then
  usage 1
fi

# Get the patch text.
patch_text=$(get_patch "$commit_id")
if [ "$?" -ne 0 ]; then
    echo "Error: Failed to get patch text." >&2
    exit 1
fi

# Send the email.
send_email "$recipient" "$patch_text"
if [ "$?" -ne 0 ]; then
  echo "Error: Failed to send email." >&2
  exit 1
fi

echo "Patch sent successfully to $recipient"

exit 0
