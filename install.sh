#!/usr/bin/env bash
set -euo pipefail

# Install git-commit-report
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/install.sh | bash
#   ./install.sh                        # Install to /usr/local/bin or ~/.local/bin
#   ./install.sh --prefix ~/.local/bin  # Install to custom directory
#   ./install.sh --uninstall            # Remove

BIN_NAME="git-commit-report"
REPO_URL="https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/git-commit-report"

BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Parse arguments
INSTALL_DIR="${GIT_COMMIT_REPORT_INSTALL_DIR:-}"
UNINSTALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --uninstall) UNINSTALL=true; shift ;;
    --prefix)    INSTALL_DIR="$2"; shift 2 ;;
    *)           echo -e "${RED}Unknown option: $1${RESET}"; exit 1 ;;
  esac
done

# Determine install directory if not specified
if [ -z "$INSTALL_DIR" ]; then
  if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
  elif [ -d "${HOME}/.local/bin" ]; then
    INSTALL_DIR="${HOME}/.local/bin"
  else
    INSTALL_DIR="${HOME}/.local/bin"
  fi
fi

# Expand ~ in INSTALL_DIR
INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

if [ "$UNINSTALL" = true ]; then
  if [ -f "${INSTALL_DIR}/${BIN_NAME}" ]; then
    rm -f "${INSTALL_DIR}/${BIN_NAME}"
    echo -e "${GREEN}Uninstalled ${BIN_NAME} from ${INSTALL_DIR}${RESET}"
  else
    echo -e "${RED}${BIN_NAME} is not installed in ${INSTALL_DIR}.${RESET}"
    # Check common locations
    for dir in /usr/local/bin "${HOME}/.local/bin"; do
      if [ "$dir" != "$INSTALL_DIR" ] && [ -f "${dir}/${BIN_NAME}" ]; then
        echo -e "  Found in ${dir}. Run: ${BOLD}./install.sh --prefix ${dir} --uninstall${RESET}"
      fi
    done
  fi
  exit 0
fi

echo -e "${BOLD}Installing ${BIN_NAME}...${RESET}"
echo "  Target: ${INSTALL_DIR}"

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
  mkdir -p "$INSTALL_DIR" 2>/dev/null || sudo mkdir -p "$INSTALL_DIR"
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

# Check if install dir is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo -e "${YELLOW}Note: ${INSTALL_DIR} is not in your PATH.${RESET}"
  echo "  Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
  echo ""
  echo "    export PATH=\"${INSTALL_DIR}:\$PATH\""
  echo ""
fi
