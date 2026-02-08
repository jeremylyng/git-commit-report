#!/usr/bin/env bash
set -euo pipefail

# Install git-commit-report to /usr/local/bin
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/install.sh | bash
#   ./install.sh                    # Install from local clone
#   ./install.sh --uninstall        # Remove

INSTALL_DIR="/usr/local/bin"
BIN_NAME="git-commit-report"
REPO_URL="https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/git-commit-report"

BOLD='\033[1m'
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

if [ "${1:-}" = "--uninstall" ]; then
  if [ -f "${INSTALL_DIR}/${BIN_NAME}" ]; then
    rm -f "${INSTALL_DIR}/${BIN_NAME}"
    echo -e "${GREEN}Uninstalled ${BIN_NAME}${RESET}"
  else
    echo -e "${RED}${BIN_NAME} is not installed.${RESET}"
  fi
  exit 0
fi

echo -e "${BOLD}Installing ${BIN_NAME}...${RESET}"

# If running from a local clone, use the local file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/${BIN_NAME}" ]; then
  SOURCE="${SCRIPT_DIR}/${BIN_NAME}"
  echo "  Source: local clone"
else
  # Download from GitHub
  SOURCE="$(mktemp)"
  trap 'rm -f "$SOURCE"' EXIT
  echo "  Downloading from GitHub..."
  curl -fsSL "$REPO_URL" -o "$SOURCE"
fi

# Ensure install directory exists
if [ ! -d "$INSTALL_DIR" ]; then
  echo "  Creating ${INSTALL_DIR}..."
  sudo mkdir -p "$INSTALL_DIR"
fi

# Copy and set permissions
if [ -w "$INSTALL_DIR" ]; then
  cp "$SOURCE" "${INSTALL_DIR}/${BIN_NAME}"
  chmod +x "${INSTALL_DIR}/${BIN_NAME}"
else
  echo "  Requires sudo to write to ${INSTALL_DIR}"
  sudo cp "$SOURCE" "${INSTALL_DIR}/${BIN_NAME}"
  sudo chmod +x "${INSTALL_DIR}/${BIN_NAME}"
fi

echo ""
echo -e "${GREEN}Installed successfully!${RESET}"
echo ""
echo "  You can now run:"
echo -e "    ${BOLD}git commit-report${RESET}          (as a git subcommand)"
echo -e "    ${BOLD}git-commit-report${RESET}          (standalone)"
echo ""
echo "  Try it: git commit-report -d 7"
