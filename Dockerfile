####### W: 3.0.3-3.13-trixie
FROM mcr.microsoft.com/devcontainers/python:3.13-trixie AS builder
WORKDIR /tmp/build
COPY requirements.txt .

ENV PIP_ROOT_USER_ACTION=ignore

RUN python -m pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
                --target=/install -r requirements.txt


#######
FROM mcr.microsoft.com/devcontainers/python:3.13-trixie

COPY --from=builder /install /usr/local/lib/python3.13/site-packages

RUN apt-get update && apt-get install -y libaio1t64 libaio-dev unzip curl python3-venv && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/oracle

RUN curl -o instantclient-basic.zip https://download.oracle.com/otn_software/linux/instantclient/1929000/instantclient-basic-linux.x64-19.29.0.0.0dbru.zip && \
    unzip -o instantclient-basic.zip && \
    rm instantclient-basic.zip

RUN ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_29:$LD_LIBRARY_PATH
ENV ORACLE_HOME=/opt/oracle/instantclient_19_29
ENV ORACLE_INSTANTCLIENT_PATH=/opt/oracle/instantclient_19_29

COPY --chown=vscode:vscode ./py-apps/ /home/vscode/py-apps/
RUN su vscode -c "pytest -v /home/vscode/py-apps/tests/"

# Ensure VS Code server directories exist with correct permissions
RUN mkdir -p /home/vscode/.vscode-server/extensions && \
    mkdir -p /home/vscode/.vscode-server/data && \
    chown -R vscode:vscode /home/vscode/.vscode-server

    
# Clean up temporary extension files but keep installed extensions
RUN rm -rf /tmp/extensions && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    

# Set a reasonable workdir for VS Code
WORKDIR /workspaces/app

CMD ["sleep", "infinity"]