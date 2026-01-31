# Capabilit CLI

> **Note:** This is the public releases repository. Source code is maintained in a private repository.

Official CLI tool for [Capabilit.ai](https://capabilit.ai) - A marketplace for AI agent skills and capabilities.

## Installation

### Quick Install (Recommended)

Install on macOS, Linux, or Windows with a single command:

```bash
curl -fsSL https://capabilit.ai/install.sh | sh
```

Or install to a specific directory:

```bash
CAPABILIT_INSTALL_DIR=/usr/local/bin curl -fsSL https://capabilit.ai/install.sh | sh
```

### Package Managers (Coming Soon)

We're working on official packages for popular package managers:

- **Homebrew** (macOS/Linux) - Coming soon
- **Chocolatey** (Windows) - Coming soon

### Manual Installation

Download the latest release for your platform from the [Releases](https://github.com/capabilit-ai/capabilit/releases) page:

| Platform | Architecture | Download |
|----------|--------------|----------|
| macOS | Intel | [capabilit-darwin-amd64.tar.gz](https://github.com/capabilit-ai/capabilit/releases/latest/download/capabilit-darwin-amd64.tar.gz) |
| macOS | Apple Silicon (M1/M2/M3) | [capabilit-darwin-arm64.tar.gz](https://github.com/capabilit-ai/capabilit/releases/latest/download/capabilit-darwin-arm64.tar.gz) |
| Linux | x64 | [capabilit-linux-amd64.tar.gz](https://github.com/capabilit-ai/capabilit/releases/latest/download/capabilit-linux-amd64.tar.gz) |
| Linux | ARM64 | [capabilit-linux-arm64.tar.gz](https://github.com/capabilit-ai/capabilit/releases/latest/download/capabilit-linux-arm64.tar.gz) |
| Windows | x64 | [capabilit-windows-amd64.zip](https://github.com/capabilit-ai/capabilit/releases/latest/download/capabilit-windows-amd64.zip) |

Extract and add to your PATH:

```bash
# macOS/Linux
tar -xzf capabilit-*.tar.gz
sudo mv capabilit /usr/local/bin/

# Verify installation
capabilit --version
```

```powershell
# Windows (PowerShell)
Expand-Archive capabilit-windows-amd64.zip
Move-Item capabilit.exe C:\Windows\System32\
```

### Install with Go

If you have Go installed:

```bash
go install github.com/capabilit-ai/capabilit/cmd/capabilit@latest
```

## Quick Start

```bash
# Authenticate with Capabilit.ai
capabilit login

# Create a new skill
capabilit init my-skill -d "My awesome skill"

# Navigate to your skill directory
cd my-skill

# Validate your skill
capabilit lint

# Publish to marketplace
capabilit publish --price 500

# Install a skill from marketplace
capabilit install <skill-id>

# Activate an installed skill
capabilit activate <skill-name>
```

## Usage

### Authentication

```bash
# Login with browser OAuth
capabilit login

# Login with API URL
capabilit login --api-url https://api.capabilit.ai

# Logout
capabilit logout
```

### Skill Creation

```bash
# Create a new skill
capabilit init my-skill -d "Description"

# Create in specific directory
capabilit init my-skill -d "Description" --dir ./projects/
```

### Skill Development

```bash
# Validate skill
capabilit lint

# Validate specific skill
capabilit lint ./path/to/skill

# Sign skill with your key
capabilit sign

# Generate new signing key
capabilit generate-key
capabilit generate-key ./my-key.pem
```

### Publishing

```bash
# Publish with one-time pricing
capabilit publish --price 500

# Publish with subscription pricing
capabilit publish --price 1000 --pricing-model subscription

# Publish with custom name and version
capabilit publish --name my-skill --version 2.0.0 --price 750
```

### Installation & Activation

```bash
# Install a skill
capabilit install <skill-id>

# Activate skill (project scope)
capabilit activate <skill-name>

# Activate skill (user scope - global)
capabilit activate <skill-name> --scope user

# Deactivate skill
capabilit deactivate <skill-name>
```

### Help

```bash
# General help
capabilit --help

# Command-specific help
capabilit publish --help
capabilit install --help
```

## Features

- 🔐 **Secure Authentication** - Browser-based OAuth flow with local credential storage
- 📦 **Skill Management** - Create, validate, and publish Claude Code skills
- 🔒 **Cryptographic Signing** - Ed25519 signatures for skill verification
- 🚀 **Easy Distribution** - One-command installation and activation
- 💰 **Marketplace Integration** - Monetize your AI skills with flexible pricing
- 🎯 **Type-Aware Installation** - Automatically places skills, agents, and plugins in correct locations
- 🔧 **Multiple Pricing Models** - One-time, subscription, or usage-based pricing

## Documentation

- [Getting Started](https://capabilit.ai/docs)
- [Creating Skills](https://capabilit.ai/docs/creating-skills)
- [Publishing Guide](https://capabilit.ai/docs/publishing)
- [API Reference](https://capabilit.ai/docs/api)
- [Marketplace](https://capabilit.ai/marketplace)

## Configuration

Capabilit stores configuration in `~/.capabilit/`:

```
~/.capabilit/
├── credentials.yaml    # Authentication credentials
├── managed.yaml        # Installed skills metadata
├── bin/               # CLI binary location
└── skills/            # Installed skill packages
```

### Environment Variables

- `CAPABILIT_API_URL` - Override API endpoint (default: https://api.capabilit.ai)
- `CAPABILIT_API_KEY` - API key for non-interactive authentication
- `CAPABILIT_INSTALL_DIR` - Override installation directory

## Examples

### Create and Publish a Skill

```bash
# Initialize
capabilit init code-reviewer -d "AI-powered code review assistant"
cd code-reviewer

# Add commands (create .md files in commands/ directory)
# ... edit your skill files ...

# Validate
capabilit lint

# Publish
capabilit login
capabilit publish --price 999 --pricing-model one_time
```

### Install and Use a Skill

```bash
# Install
capabilit install abc123-def456-skill-id

# Activate globally
capabilit activate code-reviewer --scope user

# Now use in Claude Code
# /code-reviewer analyze my-file.ts
```

## Support

- 📧 Email: [support@capabilit.ai](mailto:support@capabilit.ai)
- 🐛 Issues: [GitHub Issues](https://github.com/capabilit-ai/capabilit/issues)
- 📚 Documentation: [capabilit.ai/docs](https://capabilit.ai/docs)
- 💬 Discord: [Join our community](https://discord.gg/capabilit)

## Changelog

See [Releases](https://github.com/capabilit-ai/capabilit/releases) for version history and release notes.

## License

Proprietary - All rights reserved

---

Made with ❤️ by the Capabilit.ai team
