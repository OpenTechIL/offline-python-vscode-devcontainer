# Offline Python Dockers devcontainers Development environment

This project provides a devcontainers for vscode development environment of Python applications in offline and air-gapped environments.

Note: I prefer using `podman` instead `docker`, so whenever i write `podman` you can use it also with `docker`


## Quick start
### VSCode with podman

#### VS Code User Settings (Host Side)
Press CTRL-SHIFT-P, and wirte `Open your User Settings (JSON)` on the host machine:

```json
{
    "dev.containers.dockerPath": "podman",
    "dev.containers.dockerComposePath": "podman-compose",
    // Window? "dev.containers.dockerSocketPath": "/var/run/podman.sock",
    "dev.containers.mountWaylandSocket": false,
    "remote.downloadExtensionsLocally": true,
    "remote.autoInstallAdditionalExtensions": false,
    "dev.containers.copyGitConfig": false    

}
```

### VSCode Workspace devecontiner.json example
```json
{
    "name": "Python Airgapped (Podman)",
    "image": "offline-python-vscode-devcontainer:dev-latest-local",
    "runArgs": [
        "--userns=keep-id",
        "--security-opt", "label=disable" // Disables SELinux labeling if causing issues
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
                "extensions.ignoreRecommendations": true, // Stops VS Code from prompting you to install "helpful" extensions.
                "extensions.autoUpdate": false,
                "extensions.autoCheckUpdates": false
            }
        }
    },

    "updateRemoteUserUID": true,
    "overrideCommand": false
}
```


### use local
```bash
    #simulate python file
    echo "print('test')" > test.py
    
    # mounte python with -v and run command -it
    podman run \
        -v ./test.py:/test.py:Z \
        -it ghcr.io/opentechil/offline-python-vscode-devcontainer:latest \
        python ./test.py    

    # more allegant way to mount to /home/appuser/test.py

    # clean
    rm test.py
    
```
### prepare for offline

```bash
# get the docker
podman pull ghcr.io/opentechil/offline-python-vscode-devcontainer:latest

# create offline image
podman save -o offline-python-vscode-devcontainer.tar ghcr.io/opentechil/offline-python-vscode-devcontainer:latest

# copy to offline some how

# load image
podman load -i offline-python-vscode-devcontainer.tar

# use
podman run \
        -v ./test.py:/test.py:Z \
        -it ghcr.io/opentechil/offline-python-vscode-devcontainer:latest \
        python ./test.py 
```

## Getting Started

To get started with OfflinePythonDockers, clone the repository and follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/opentechil/offline-python-vscode-devcontainer.git
    cd offline-python-vscode-devcontainer
    ```
2.  **Build Docker images:**
    ```bash
    podman build . -t offline-python-vscode-devcontainer:dev-latest-local
    
3. **Run python**
    TL;DR:
    ```bash
        podman run -v ./your-python-dir:/home/appuser/your-python-dir:Z \
        -it localhost/offline-python-vscode-devcontainer:dev \
        python ./your-python-dir/file.py
    ```

    Full example:
    ```bash
    # Create folder to share with docker
    mkdir -p ./your-python-dir

    # Write a code
    echo 'print ("Hello world!")' > ./your-python-dir/file.py
    
    # Run it
    podman run \
        -v ./your-python-dir:/home/appuser/your-python-dir:Z \
        -it localhost/offline-python-vscode-devcontainer:dev \
        python ./your-python-dir/file.py

    #output> Hello world!
    ```

## How To
### Add python package for offline
1. just edit the `requirements.txt` file and add packages
2. build docker `podman build . -t offline-python-vscode-devcontainer:dev-latest-local`
3. run it

### Export to offline use
- Just use `podman save -o my-offline-py.tar offline-python-vscode-devcontainer:dev-latest-local`
- copy the tar
- then `podman load -i my-offline-py.tar`

## Troubleshooting

### Space on linux 
some times becuse limit `/tmp` folder 

    copying layers and metadata for container "": initializing source
     containers-storage:working-container: storing layer "" to file: on copy: 
     writing to tar filter pipe (closed=false,err=reading tar archive: 
     copying content for "home/appuser/.local/lib/python3.13/site-packages/package/somefile.py":
     write /var/tmp/buildah35812317/layer: no space left on device):
     write /var/tmp/buildah35812317/layer: no space left on device

Solution:
```bash
    mkdir -p ~/podman-tmp
    export TMPDIR=~/podman-tmp
```

## Contributing

We encourage contributions! Please read our [`CONTRIBUTORS.md`](./CONTRIBUTORS.md) for guidelines on:
*   Reporting bugs
*   Suggesting enhancements
*   Submitting pull requests
*   Code style and conventions

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
