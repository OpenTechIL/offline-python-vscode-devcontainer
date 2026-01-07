# AGENT GUIDELINES FOR OFFLINE PYTHON DEVCONTAINER PROJECT

## Overview
This document provides essential guidelines for agents operating within the `offline-python-vscode-devcontainer` repository. This project focuses on providing an offline and air-gapped development environment for Python applications using Docker/Podman devcontainers. The emphasis is on container management and environment setup, complemented by Python application development best practices.

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

*   **Run tests with coverage (inside the container):**
    ```bash
    pytest -v --cov=/home/vscode/py-apps /home/vscode/py-apps/tests/
    ```

## 2. Code Style Guidelines

Given that this is a container project, these guidelines focus on Dockerfile and `devcontainer.json` conventions, supplemented with Python code style for applications running within the containers.

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
*   **Dependency Management**: Python dependencies are managed via runtime image wheelhouse. Core packages are provided by the base runtime image (`ghcr.io/opentechil/offline-python-runtime-docker:v1.1.0-release.0`), while additional packages can be installed at runtime or via project-specific `requirements.txt` for persistent installations.
*   **Offline Focus**: All configurations and scripts should prioritize and support the offline/air-gapped nature of the development environment.

## 3. Development Workflow

### 3.1. Container Testing
Always test changes within the container environment:
```bash
# Build with changes
podman build . -t offline-python-vscode-devcontainer:test

# Run tests
podman run -it offline-python-vscode-devcontainer:test pytest -v /home/vscode/py-apps/tests/
```

### 3.2. Package Management
- **Runtime Image**: Core packages come from the base runtime image
- **Project Requirements**: Add application-specific packages to `requirements.txt`
- **Offline Packages**: For true offline deployment, packages must be added to the runtime image repository

### 3.3. Security Considerations
- Always use non-root execution (`remoteUser: "vscode"`)
- Include proper SELinux contexts for mounted volumes (`:Z` flag)
- Validate input and sanitize data in Python applications
- Use environment variables for configuration, not hardcoded values

## 4. Environment Variables and Configuration

Key environment variables used in this project:
- `ORACLE_INSTANTCLIENT_PATH`: Path to Oracle Instant Client libraries
- `PODMAN_USERNS`: User namespace configuration for Podman
- `PYTHONPATH`: Python module search path (if needed)

## 5. Troubleshooting Common Issues

### 5.1. Container Issues
- **Permission denied**: Use `:Z` flag on volume mounts for SELinux
- **Space issues**: Set `TMPDIR` environment variable for build temp space
- **Network issues**: This is an offline-first container - expect limited network access

### 5.2. Python Issues
- **Import errors**: Verify packages are in runtime image or requirements.txt
- **Oracle client errors**: Check `ORACLE_INSTANTCLIENT_PATH` environment variable
- **Test failures**: Run tests inside container, not on host system

## 6. Repository Structure Understanding

```
offline-python-vscode-devcontainer/
├── Dockerfile                 # Multi-stage container build
├── AGENTS.md                  # This file - agent guidelines
├── README.md                  # Main project documentation
├── CONTRIBUTORS.md            # Git flow and contribution guidelines
├── .github/workflows/         # CI/CD pipelines
├── py-apps/                   # Test applications and examples
│   ├── main.py               # Simple test script
│   ├── requirements.txt      # Additional Python packages
│   └── tests/                # pytest test suite
│       ├── test_imports.py   # Package import validation
│       └── test_thick_oracle.py # Oracle client testing
└── devcontiner-workspace.example/  # Example workspace setup
```

Remember: This project's primary focus is providing the container infrastructure. Python applications that run within should follow these guidelines, but the main emphasis remains on container management, offline deployment, and DevContainer integration.