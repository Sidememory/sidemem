FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    bash coreutils findutils sudo curl git nano ranger && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 pilot && \
    useradd -u 1000 -g pilot -m -s /bin/bash pilot && \
    echo 'pilot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pilot
WORKDIR /home/pilot

# 1. Install Opencode into the image (This acts as our 'Master Copy')
RUN curl -fsSL https://opencode.ai/install | bash

# 2. Prepare the redirections
# We move the install to a template so the 'real' path is free for the Symlink
RUN mkdir -p /home/pilot/brain_template && \
    mv /home/pilot/.opencode /home/pilot/brain_template/ && \
    ln -s /home/pilot/brain/.opencode /home/pilot/.opencode && \
    ln -s /home/pilot/brain/.local /home/pilot/.local && \
    ln -s /home/pilot/brain/.config /home/pilot/.config

ENV PATH="/home/pilot/.opencode/bin:${PATH}"
WORKDIR /home/pilot/workspace
CMD ["/bin/bash"]