# AGENT GUIDELINES FOR OFFLINE PYTHON DEVCONTAINER PROJECT

## Overview
This document provides essential guidelines for agents operating within the `offline-python-vscode-devcontainer` repository. This project focuses on providing an offline and air-gapped development environment for Python applications using Docker/Podman devcontainers. The emphasis is on container management and environment setup, rather than specific Python application code style.

## 1. Build, Lint, and Test Commands

### 1.1. Build Commands

To build the primary Docker/Podman image locally:
```bash
podman build . -t offline-python-vscode-devcontainer:dev-latest-local
```
This command should be executed from the root of the repository where the `Dockerfile` is located.

### 1.2. Linting/Static Analysis

Currently, there are no explicit linting commands configured for the Dockerfiles or `devcontainer.json` files. Agents should adhere to best practices for Dockerfile and JSON formatting to maintain readability.

### 1.3. Test Commands

Tests for Python applications *within* the devcontainer are run using `pytest`.

*   **Run all tests (inside the container):**
    ```bash
    pytest -v /home/vscode/py-apps/tests/
    ```
    This command is executed as part of the Dockerfile build process (`RUN su vscode -c "pytest -v /home/vscode/py-apps/tests/"`) but can also be run manually inside a running container instance.

*   **Run a single test file (inside the container):**
    ```bash
    pytest -v /home/vscode/py-apps/tests/<test_file.py>
    ```
    Replace `<test_file.py>` with the actual path to the test file (e.g., `/home/vscode/py-apps/tests/test_imports.py`).

*   **Run a single test function within a file (inside the container):**
    ```bash
    pytest -v /home/vscode/py-apps/tests/<test_file.py>::<test_function_name>
    ```
    Replace `<test_file.py>` and `<test_function_name>` accordingly.

## 2. Code Style Guidelines

Given that this is a container project, these guidelines focus on Dockerfile and `devcontainer.json` conventions. Python-specific code style is left to the individual Python projects that will utilize these devcontainers.

### 2.1. Dockerfile Best Practices

*   **Multi-stage Builds**: Use multi-stage builds (as seen in the project's `Dockerfile`) to keep final images small and clean.
*   **Layer Caching**: Order instructions to leverage Docker's layer caching effectively. Place frequently changing instructions (like `COPY` application code) later in the Dockerfile.
*   **Minimize Layers**: Combine `RUN` commands using `&&` to reduce the number of layers.
*   **Clean Up**: Always clean up temporary files and caches (`apt-get clean`, `rm -rf /var/lib/apt/lists/*`, etc.) at the end of `RUN` commands to reduce image size.
*   **Security**: Follow security best practices, such as running processes with a non-root user (`remoteUser: "vscode"`, `su vscode -c "..."`).
*   **Clarity**: Use comments where necessary to explain complex steps.

### 2.2. `devcontainer.json` Guidelines

*   **Image Specification**: Clearly define the base image (`"image"`).
*   **Run Arguments**: Include necessary `runArgs` for container security and user namespace management (`--userns=keep-id`, `--security-opt label=disable`).
*   **Remote User**: Specify `"remoteUser"` to ensure development is done with appropriate user permissions (e.g., `"vscode"`).
*   **VS Code Settings**:
    *   Configure `python.defaultInterpreterPath` to point to the correct Python interpreter within the container.
    *   Set `python.languageServer` (e.g., `"Pylance"`).
    *   Manage extension behavior: set `"extensions.ignoreRecommendations": true`, `"extensions.autoUpdate": false`, and `"extensions.autoCheckUpdates": false` for controlled offline environments.
    *   Control extension syncing with `remote.extensionKind`.
*   **`updateRemoteUserUID`**: Set to `true` to ensure user IDs are correctly synchronized.

### 2.3. Git Flow Conventions

The project adheres to the `git-flow` branching model:

*   **`develop` Branch**: Main development branch for new features.
*   **`feature` Branches**: For new features, branched from `develop` and merged back into `develop`. Use `git flow feature start <feature-name>`.
*   **`release` Branch**: Contains official release history. Created from `develop` for release preparation and merged into `release` and `develop`. Use `git flow release start <version>`.
*   **`hotfix` Branches**: For urgent bug fixes on `release`. Branched from `release` and merged into both `release` and `develop`. Use `git flow hotfix start <hotfix-name>`.
*   **`bugfix` Branches**: For new bug fixes. Branched from `develop` and merged back into `develop`. Use `git flow bugfix start <bugfix-name>`.

### 2.4. General Project Conventions

*   **Documentation**: Ensure `README.md` and `CONTRIBUTORS.md` are kept up-to-date.
*   **Dependency Management**: Python dependencies are managed via `requirements.txt`. Any additions should be made there and trigger a Docker image rebuild.
*   **Offline Focus**: All configurations and scripts should prioritize and support the offline/air-gapped nature of the development environment.
