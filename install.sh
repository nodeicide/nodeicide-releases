#!/usr/bin/env bash
set -euo pipefail

if ! command -v git &>/dev/null; then
  echo "Error: Please install git and add it to your PATH." >&2
  exit 1
fi

ARCH=$(uname -m)
case "$ARCH" in
x86_64)
  ARCH="amd64"
  ;;
aarch64 | arm64)
  ARCH="aarch64"
  ;;
*)
  echo "Error: Unsupported architecture: $ARCH" >&2
  exit 1
  ;;
esac

if [[ $EUID -eq 0 ]]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="$HOME/.local/bin"
fi

if ! mkdir -p "$INSTALL_DIR" 2>/dev/null; then
  echo "Error: Permission denied creating directory '$INSTALL_DIR'." >&2
  echo "Please re-run this script with elevated privileges:" >&2
  echo "  sudo $0" >&2
  exit 1
fi

VERSION="0.2.0"
BINARY_NAME="nodeicide-0.2-${ARCH}"
URL="https://github.com/nodeicide/nodeicide-releases/releases/download/${VERSION}/${BINARY_NAME}"

echo "Downloading nodeicide (${ARCH}) to ${INSTALL_DIR}..."

if ! curl -fsSL -o "${INSTALL_DIR}/nodeicide" "$URL" 2>/dev/null; then
  echo "Error: Failed to write binary to '$INSTALL_DIR' (Permission denied)." >&2
  echo "Please re-run this script using sudo:" >&2
  echo "  sudo $0" >&2
  exit 1
fi

chmod +x "${INSTALL_DIR}/nodeicide"

if [[ $EUID -ne 0 ]]; then
  PATH_LINE="export PATH=\"$INSTALL_DIR:\$PATH\""

  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Configuring PATH..."
    UPDATED=false

    for profile in "$HOME/.profile" "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.zshrc"; do
      if [[ -w "$profile" || (! -e "$profile" && -w "$(dirname "$profile")") ]]; then
        if ! grep -qs "$INSTALL_DIR" "$profile" 2>/dev/null; then
          echo "" >>"$profile"
          echo "# Added by nodeicide installer" >>"$profile"
          echo "$PATH_LINE" >>"$profile"
          echo " -> Added $INSTALL_DIR to $profile"
          UPDATED=true
        fi
      fi
    done

    if [[ "$UPDATED" == "false" ]]; then
      echo ""
      echo "Notice: Could not modify shell profile files automatically due to permissions (e.g., NixOS)."
      echo "To finish setup, manually add this line to your shell configuration:"
      echo "  $PATH_LINE"
    fi
  fi
fi

echo ""
echo "Successfully installed nodeicide!"

echo "run <nodeicide -v> and if it does not work"
echo "run <export PATH=\"\$HOME/.local/bin:\$PATH\">"
