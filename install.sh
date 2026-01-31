#!/bin/sh
set -e

# Capabilit CLI installer
# Usage: curl -fsSL https://capabilit.ai/install.sh | sh

INSTALL_DIR="${CAPABILIT_INSTALL_DIR:-$HOME/.capabilit/bin}"
BASE_URL="${CAPABILIT_DOWNLOAD_URL:-https://github.com/capabilit-ai/capabilit/releases/latest/download}"
VERSION="${CAPABILIT_VERSION:-latest}"

# Colors (only if terminal supports it)
if [ -t 1 ]; then
    BOLD='\033[1m'
    DIM='\033[2m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    RESET='\033[0m'
else
    BOLD='' DIM='' GREEN='' YELLOW='' RED='' RESET=''
fi

info() { printf "${BOLD}%s${RESET}\n" "$1"; }
success() { printf "${GREEN}%s${RESET}\n" "$1"; }
warn() { printf "${YELLOW}%s${RESET}\n" "$1"; }
error() { printf "${RED}error:${RESET} %s\n" "$1" >&2; exit 1; }

detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "darwin" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) error "Unsupported operating system: $(uname -s)" ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64) echo "amd64" ;;
        arm64|aarch64) echo "arm64" ;;
        *) error "Unsupported architecture: $(uname -m)" ;;
    esac
}

detect_shell_profile() {
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
        echo "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ]; then
        if [ -f "$HOME/.bash_profile" ]; then
            echo "$HOME/.bash_profile"
        else
            echo "$HOME/.bashrc"
        fi
    elif [ -f "$HOME/.profile" ]; then
        echo "$HOME/.profile"
    else
        echo ""
    fi
}

download() {
    url="$1"
    dest="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$url"
    else
        error "Neither curl nor wget found. Install one and try again."
    fi
}

# --- Main ---

printf "\n"
info "  Capabilit CLI Installer"
printf "${DIM}  https://capabilit.ai${RESET}\n\n"

OS=$(detect_os)
ARCH=$(detect_arch)

info "Detected: ${OS}/${ARCH}"

# Determine binary name
BIN_NAME="capabilit"
if [ "$OS" = "windows" ]; then
    BIN_NAME="capabilit.exe"
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Try downloading pre-built binary
ARCHIVE_NAME="capabilit-${OS}-${ARCH}.tar.gz"
DOWNLOAD_URL="${BASE_URL}/${ARCHIVE_NAME}"

printf "Downloading ${DIM}%s${RESET}..." "$ARCHIVE_NAME"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

if download "$DOWNLOAD_URL" "$TMP_DIR/$ARCHIVE_NAME" 2>/dev/null; then
    printf " done\n"
    # Extract
    tar -xzf "$TMP_DIR/$ARCHIVE_NAME" -C "$TMP_DIR"
    mv "$TMP_DIR/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"
    chmod +x "$INSTALL_DIR/$BIN_NAME"
else
    printf " not found\n"
    # Fallback: try go install
    if command -v go >/dev/null 2>&1; then
        warn "Pre-built binary not available. Building from source..."
        if [ "$VERSION" = "latest" ]; then
            go install github.com/capabilit-ai/capabilit/cmd/capabilit@latest
        else
            go install "github.com/capabilit-ai/capabilit/cmd/capabilit@${VERSION}"
        fi
        # Move from GOPATH/bin to our install dir
        GO_BIN="$(go env GOPATH)/bin/$BIN_NAME"
        if [ -f "$GO_BIN" ]; then
            cp "$GO_BIN" "$INSTALL_DIR/$BIN_NAME"
            chmod +x "$INSTALL_DIR/$BIN_NAME"
        else
            error "go install succeeded but binary not found at $GO_BIN"
        fi
    else
        error "No pre-built binary available for ${OS}/${ARCH} and Go is not installed.\nInstall Go from https://go.dev/dl/ and try again."
    fi
fi

# Verify installation
if [ ! -x "$INSTALL_DIR/$BIN_NAME" ]; then
    error "Installation failed: binary not found at $INSTALL_DIR/$BIN_NAME"
fi

# Create ~/.capabilit directory structure
mkdir -p "$HOME/.capabilit/skills"

# Add to PATH if needed
NEEDS_PATH=false
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *) NEEDS_PATH=true ;;
esac

if [ "$NEEDS_PATH" = true ]; then
    PROFILE=$(detect_shell_profile)
    PATH_LINE="export PATH=\"\$PATH:$INSTALL_DIR\""

    if [ -n "$PROFILE" ]; then
        # Check if already added
        if ! grep -q "capabilit/bin" "$PROFILE" 2>/dev/null; then
            printf "\n# Capabilit CLI\n%s\n" "$PATH_LINE" >> "$PROFILE"
            info "Added to PATH in $PROFILE"
        fi
    fi
fi

# Print success
printf "\n"
success "Capabilit CLI installed successfully!"
printf "\n"
printf "  Location: ${BOLD}%s${RESET}\n" "$INSTALL_DIR/$BIN_NAME"
printf "  Version:  $("$INSTALL_DIR/$BIN_NAME" --version 2>/dev/null || echo "installed")\n"
printf "\n"

if [ "$NEEDS_PATH" = true ]; then
    warn "Restart your terminal or run:"
    printf "  ${BOLD}export PATH=\"\$PATH:%s\"${RESET}\n" "$INSTALL_DIR"
    printf "\n"
fi

printf "Get started:\n"
printf "  ${BOLD}capabilit init my-skill -d \"My awesome skill\"${RESET}\n"
printf "  ${BOLD}capabilit lint${RESET}\n"
printf "  ${BOLD}capabilit --help${RESET}\n"
printf "\n"
