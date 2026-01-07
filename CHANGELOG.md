# 📝 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-01-07

### 🚀 Updates
- **Runtime Image Update**: Updated to `ghcr.io/opentechil/offline-python-runtime-docker:v1.1.0-release.0`
- **Documentation Enhancement**: Added clear guidance on offline package management process
- **Repository Links**: Added direct links to runtime image repository for package requests

### 📦 Package Management
- **Offline Package Process**: Documented process for adding packages to offline environments via runtime image
- **Repository Integration**: Enhanced documentation linking to [runtime image repository](https://github.com/OpenTechIL/offline-python-runtime-docker)

---

## [1.1.0] - 2026-01-07

### 🚀 Major Changes
- **Runtime Image Integration**: Now uses `ghcr.io/opentechil/offline-python-runtime-docker:v1.0.0-release.0` as base image
- **Runtime Package Management**: Wheelhouse and package management moved to runtime for better compatibility

### ✨ New Features
- **Oracle Driver Support**: Leverages Oracle Instant Client from runtime image
- **Runtime Wheelhouse**: Package installation handled at runtime through pre-configured wheelhouse system
- **Simplified Architecture**: Removed local `requirements.txt` dependencies, now managed by runtime image

### 🔄 Changes
- **Package Management**: Core packages (pandas, oracledb, cryptography, etc.) now provided by runtime image
- **Build Process**: Streamlined build process leveraging runtime image foundation
- **Compatibility**: Enhanced offline compatibility through runtime wheelhouse system
- **Runtime Repository**: Integration with [offline-python-runtime-docker](https://github.com/OpenTechIL/offline-python-runtime-docker) repository

### 📦 Package Updates
- Core Python packages now sourced from runtime image
- Oracle Instant Client 19.29 included via runtime image
- Data science stack (pandas, numpy, scikit-learn) available from runtime

### 🏗️ Architecture
- **Multi-stage build**: Runtime image as foundation with devcontainer customization
- **Optimized layers**: Better Docker layer caching and reduced build times
- **Runtime flexibility**: Package installation available both at build time and runtime

### 📚 Documentation
- Updated README.md to reflect runtime image usage
- Added runtime architecture explanations
- Updated configuration examples for runtime package management

---

## [1.0.x] - Previous Versions

### 🐛 Known Issues
- Package management complexity with local wheelhouse
- Build image size optimization needed
- Oracle driver compatibility issues in some environments

---

## Migration Guide

### From v1.0.x to v1.1.0

**Breaking Changes**:
- Local `requirements.txt` packages are no longer built into the image
- Package management now happens at runtime

**Recommended Actions**:
1. Update your development workflow to install packages at runtime:
   ```bash
   # Inside devcontainer
   pip install your-package
   ```

2. For persistent packages, create project-specific `requirements.txt` and install when container starts

3. Update build scripts to use the new runtime image base

**Benefits**:
- Faster build times
- Better package compatibility
- Simplified maintenance
- Access to runtime wheelhouse with pre-compiled packages

---

## Version Support

| Version | Status | Support End |
|---------|--------|-------------|
| 1.1.x   | ✅ Current | TBD |
| 1.0.x   | ⚠️ Legacy | 2026-03-07 |

---

*For detailed release notes and migration guides, check the [GitHub Releases](https://github.com/OpenTechIL/offline-python-vscode-devcontainer/releases) page.*