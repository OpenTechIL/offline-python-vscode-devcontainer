# 🐍 Offline Python VSCode DevContainer

[![Build Status](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/workflows/Build%20and%20Push%20to%20GHCR/badge.svg)](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/OpenTechIL/offline-python-vscode-devcontainer?style=social)](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/stargazers)
[![Python 3.13](https://img.shields.io/badge/python-3.13-blue.svg)](https://www.python.org/downloads/)
[![Podman](https://img.shields.io/badge/podman-supported-orange.svg)](https://podman.io/)
[![GHCR](https://img.shields.io/badge/ghcr-latest-blue)](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/pkgs/container/offline-python-vscode-devcontainer)

> 🚀 A complete offline and air-gapped Python development environment in VSCode DevContainers with pre-installed packages and Oracle DB support.

## 📋 Table of Contents

- [✨ Features](#-features)
- [🎯 Why This Project](#-why-this-project)
- [📋 Prerequisites](#-prerequisites)
- [⚡ Quick Start](#-quick-start)
- [🔧 Installation](#-installation)
- [💻 Usage](#-usage)
- [⚙️ Configuration](#️-configuration)
- [🔒 Security](#-security)
- [📝 Changelog](#-changelog)
- [🐛 Troubleshooting](#-bug-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## ✨ Features

- 🌐 **Offline-First**: Complete air-gapped development environment
- 🐳 **Container-Based**: Isolated development with Podman/Docker support
- 🐍 **Python 3.13**: Latest Python version with runtime image foundation
- 🗄️ **Oracle Database**: Built-in Oracle Instant Client from runtime image
- 📝 **VSCode Integration**: Seamless development experience
- 🧪 **Testing Ready**: Pre-configured pytest environment
- 🏗️ **Runtime Image Base**: Built on `ghcr.io/opentechil/offline-python-runtime-docker:v1.1.0-release.0`
- 📦 **Runtime Wheelhouse**: Package management handled at runtime for compatibility
- 🔧 **Customizable**: Easy to extend with additional packages
- 🛡️ **Security-Focused**: Non-root user execution

## 🎯 Why This Project

Traditional development environments require constant internet connectivity for package installation, updates, and VSCode extensions. This becomes problematic in:

- 🏢 **Corporate environments** with strict network policies
- 🏭 **Industrial settings** with air-gapped systems
- 🏝️ **Remote locations** with limited connectivity
- 🔒 **High-security environments** requiring isolation

This project provides a **complete, self-contained development environment** that works entirely offline, ensuring consistent development experiences across any infrastructure.

## 📋 Prerequisites

### Required Software
- **Podman** (recommended) or **Docker** 
- **VSCode** with **Dev Containers extension**
- **Git** for cloning the repository

### System Requirements
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 5GB available space
- **OS**: Linux, macOS, or Windows with WSL2

> **💡 Note**: This project uses Podman as the primary container runtime, but all commands work with Docker as well.

## ⚡ Quick Start

### One-Command Setup
```bash
git clone https://github.com/OpenTechIL/offline-python-vscode-devcontainer.git
cd offline-python-vscode-devcontainer
podman build . -t offline-python-vscode-devcontainer:dev-latest-local
```

### VSCode Integration
1. Open the project in VSCode
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Select "Dev Containers: Reopen in Container"
4. Start coding! 🎉

## 🔧 Installation

### Step 1: Clone Repository
```bash
git clone https://github.com/OpenTechIL/offline-python-vscode-devcontainer.git
cd offline-python-vscode-devcontainer
```

### Step 2: Configure VSCode (Host Side)
Press `Ctrl+Shift+P` and search for "Open User Settings (JSON)":

```json
{
    "dev.containers.dockerPath": "podman",
    "dev.containers.dockerComposePath": "podman-compose",
    "dev.containers.mountWaylandSocket": false,
    "remote.downloadExtensionsLocally": true,
    "remote.autoInstallAdditionalExtensions": false,
    "dev.containers.copyGitConfig": false
}
```

### Step 3: Build Container Image
```bash
podman build . -t offline-python-vscode-devcontainer:dev-latest-local
```

### Step 4: Configure DevContainer
Create or update `.devcontainer/devcontainer.json`:

```json
{
    "name": "Python Airgapped (Podman)",
    "image": "offline-python-vscode-devcontainer:dev-latest-local",
    "runArgs": [
        "--userns=keep-id",
        "--security-opt", "label=disable"
    ],
    "remoteUser": "vscode",
    "remoteEnv": {
        "PODMAN_USERNS": "keep-id"
    },
    "customizations": {
        "vscode": {
            "settings": {
                "python.defaultInterpreterPath": "/usr/local/bin/python",
                "python.languageServer": "Pylance",
                "extensions.ignoreRecommendations": true,
                "extensions.autoUpdate": false,
                "extensions.autoCheckUpdates": false
            }
        }
    },
    "updateRemoteUserUID": true,
    "overrideCommand": false
}
```

## 💻 Usage

### Basic Python Execution
```bash
# Create a test file
echo "print('Hello from offline container!')" > test.py

# Run in container
podman run \
    -v ./test.py:/home/vscode/test.py:Z \
    -it offline-python-vscode-devcontainer:dev-latest-local \
    python /home/vscode/test.py
```

### Development Workflow
```bash
# Create project directory
mkdir -p ./my-python-project
cd ./my-python-project

# Create Python file
cat > main.py << 'EOF'
import pandas as pd
import oracledb

print("🐍 Python environment ready!")
print(f"📊 Pandas version: {pd.__version__}")
print(f"🗄️ Oracle DB available: {oracledb.__version__}")
print(f"🏗️ Runtime image foundation active")
EOF

# Run with mounted volume
podman run \
    -v $(pwd):/home/vscode/project:Z \
    -it offline-python-vscode-devcontainer:dev-latest-local \
    python /home/vscode/project/main.py
```

### Running Tests
```bash
# Run all tests
podman run \
    -v $(pwd):/home/vscode/project:Z \
    -it offline-python-vscode-devcontainer:dev-latest-local \
    pytest -v /home/vscode/project/tests/

# Run specific test file
podman run \
    -v $(pwd):/home/vscode/project:Z \
    -it offline-python-vscode-devcontainer:dev-latest-local \
    pytest -v /home/vscode/project/tests/test_specific.py
```

## ⚙️ Configuration

### Runtime Image Architecture
This devcontainer is built on top of the offline Python runtime image which provides:
- **Oracle Instant Client**: Full database connectivity support
- **Core Packages**: Essential Python packages pre-installed
- **Runtime Wheelhouse**: Package management handled at runtime for compatibility

**📦 Runtime Image Repository**: [github.com/OpenTechIL/offline-python-runtime-docker](https://github.com/OpenTechIL/offline-python-runtime-docker) - The base runtime image provides the core Python environment, Oracle drivers, and offline package management capabilities.

### Adding Python Packages
Since v1.1.0, package management is handled at runtime through the wheelhouse system:

1. **For container runtime**: Install packages directly in the running container:
   ```bash
   # Inside the devcontainer
   pip install numpy matplotlib seaborn
   ```

2. **For persistent packages**: Add to your project's `requirements.txt`:
   ```
   numpy
   matplotlib
   seaborn
   # Your application-specific packages
   ```

3. **Runtime wheelhouse access**: All packages are installed from the pre-configured wheelhouse for offline compatibility.

Note: Core packages (pandas, cryptography, oracledb, pytest, ipykernel) are provided by the base runtime image and available immediately.

### 📦 Adding Packages to Offline Environment

**⚠️ Important**: For packages to be available in offline environments, they must be added to the **runtime image** itself:

- **Runtime Image Repository**: [github.com/OpenTechIL/offline-python-runtime-docker](https://github.com/OpenTechIL/offline-python-runtime-docker)
- **How to Add**: Submit a PR or issue to the runtime image repository with your package requirements
- **Why**: The runtime image contains the pre-built wheelhouse that enables offline package installation

**Process for Adding New Offline Packages**:
1. Check if the package already exists in the runtime image
2. If not, open an issue or PR in the [runtime image repository](https://github.com/OpenTechIL/offline-python-runtime-docker)
3. Once included in a new runtime release, update this devcontainer to use the new version

This ensures your packages are available for true offline deployment without requiring network access.

### Custom VSCode Extensions
Update `.devcontainer/devcontainer.json`:
```json
{
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-toolsai.jupyter",
                "ms-vscode.vscode-json"
            ]
        }
    }
}
```

## 🔒 Security

### Air-Gapped Deployment
```bash
# 1. Pull image (online)
podman pull ghcr.io/opentechil/offline-python-vscode-devcontainer:latest

# 2. Save for offline transfer
podman save -o offline-python-devcontainer.tar \
    ghcr.io/opentechil/offline-python-vscode-devcontainer:latest

# 3. Transfer to air-gapped system
# (Use USB, network transfer, etc.)

# 4. Load on offline system
podman load -i offline-python-devcontainer.tar

# 5. Use offline
podman run -v ./project:/home/vscode/project:Z \
    -it ghcr.io/opentechil/offline-python-vscode-devcontainer:latest \
    python /home/vscode/project/app.py
```

### Security Features
- 🔐 **Non-root execution**: All processes run as `vscode` user
- 🛡️ **SELinux compatible**: Proper security contexts
- 🔒 **No network access**: Container runs in isolation
- 📋 **Minimal attack surface**: Only essential packages installed

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and feature updates.

## 🐛 Troubleshooting

### Common Issues

#### Space Issues on Linux
<details>
<summary>Click to expand</summary>

**Problem**: Build fails with "no space left on device"

**Solution**:
```bash
# Create temporary directory with more space
mkdir -p ~/podman-tmp
export TMPDIR=~/podman-tmp

# Then rebuild
podman build . -t offline-python-vscode-devcontainer:dev-latest-local
```
</details>

#### Permission Issues
<details>
<summary>Click to expand</summary>

**Problem**: Permission denied errors with mounted volumes

**Solution**:
```bash
# Ensure proper SELinux context
podman run \
    -v ./project:/home/vscode/project:Z \
    -it offline-python-vscode-devcontainer:dev-latest-local \
    python /home/vscode/project/app.py
```
</details>

#### VSCode Extension Issues
<details>
<summary>Click to expand</summary>

**Problem**: Extensions not installing or working

**Solution**:
1. Check VSCode settings on host
2. Ensure `remote.downloadExtensionsLocally: true`
3. Restart VSCode and container
</details>

### Getting Help
- 📖 Check [AGENTS.md](./AGENTS.md) for development guidelines
- 🐛 [Report issues](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/issues)
- 💬 Start a [discussion](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/discussions)

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTORS.md](./CONTRIBUTORS.md) for detailed guidelines.

### Development Workflow
```bash
# 1. Create feature branch
git flow feature start your-feature

# 2. Make changes
# ... edit files ...

# 3. Test your changes
podman build . -t offline-python-vscode-devcontainer:test
podman run -it offline-python-vscode-devcontainer:test pytest -v

# 4. Commit and push
git add .
git commit -m "feat: add your feature"
git push origin feature/your-feature

# 5. Create Pull Request
```

### Code Style
- Follow Dockerfile best practices
- Use multi-stage builds
- Keep images small and secure
- Test thoroughly before submitting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Microsoft Dev Containers](https://containers.dev/) for the base images
- [Podman](https://podman.io/) for container runtime
- [Python Software Foundation](https://www.python.org/) for Python
- All [contributors](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/graphs/contributors) who make this project better

---

<div align="center">

**[⬆️ Back to top](#-offline-python-vscode-devcontainer)**

Made with ❤️ for offline Python development

</div>