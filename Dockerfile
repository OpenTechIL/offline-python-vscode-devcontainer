#
# Builder image for runtime
#   The wheelhouse located there: 
#       https://github.com/OpenTechIL/offline-python-runtime-docker    
#   
#   Update exact release. not "latests" etc to be consistent
FROM ghcr.io/opentechil/offline-python-runtime-docker:v1.0.0-release.0 AS builder


#
# Actual docker for 
#
FROM mcr.microsoft.com/devcontainers/python:3.13-trixie

##
## ORACLE
##
RUN apt-get update && apt-get install -y libaio1t64 libaio-dev unzip curl python3-venv && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/oracle/instantclient_19_29 \
                    /opt/oracle/instantclient_19_29

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_29:$LD_LIBRARY_PATH
ENV ORACLE_HOME=/opt/oracle/instantclient_19_29
ENV ORACLE_INSTANTCLIENT_PATH=/opt/oracle/instantclient_19_29

RUN ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1



##
## PYTHON and wheelhouse
##
COPY --from=builder /lib/python_wheelhouse \
                    /lib/python_wheelhouse

COPY --from=builder /usr/local/lib/python3.13/site-packages \
                    /usr/local/lib/python3.13/site-packages

COPY --from=builder /etc/pip.conf \
                    /etc/pip.conf

# python testing
COPY --chown=vscode:vscode ./py-apps/ /home/vscode/py-apps/
RUN su vscode -c "cd /home/vscode/py-apps/ && \
chmod +x ./run-tests.sh && \
./run-tests.sh"


##
##  VS Code configurations
##
# Ensure VS Code server directories exist with correct permissions
RUN mkdir -p /home/vscode/.vscode-server/extensions && \
    mkdir -p /home/vscode/.vscode-server/data && \
    chown -R vscode:vscode /home/vscode/.vscode-server


##
##  Cleanups
##
# Clean up temporary extension files but keep installed extensions
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /tmp/extensions
    

# Set a reasonable workdir for VS Code
WORKDIR /workspaces/app

CMD ["sleep", "infinity"]