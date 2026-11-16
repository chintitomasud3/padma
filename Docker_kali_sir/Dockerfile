# Kali Linux image with SSH server and security tools
# Build: docker build -f dockerfilefuture.txt -t kali-custom-ssh:latest --build-arg ROOT_PASSWORD=yourpassword .
# Run:   docker run -dit --name kali-lab3 -p 12121:22 -p 8080:8080 kali-custom-ssh:latest

FROM kalilinux/kali-rolling

LABEL maintainer="Kali Linux Lab"
LABEL description="Kali Linux Networking and Security Tools with SSH access"

ENV DEBIAN_FRONTEND=noninteractive

ARG ROOT_PASSWORD=kali

# Base utilities and SSH
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    netcat-openbsd \
    tcpdump \
    traceroute \
    mtr-tiny \
    curl \
    wget \
    iputils-ping \
    net-tools \
    iproute2 \
    dnsutils \
    whois \
    openssh-client \
    openssh-server \
    git \
    vim \
    nano \
    jq \
    unzip \
    zip \
    python3 \
    python3-pip \
    python3-venv \
    procps \
    htop \
    less \
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Security and pentesting tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nmap \
    masscan \
    nikto \
    whatweb \
    wapiti \
    wpscan \
    nuclei \
    lynis \
    zaproxy \
    sqlmap \
    commix \
    gobuster \
    ffuf \
    dirb \
    enum4linux-ng \
    testssl.sh \
    sslscan \
    exploitdb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# SSH configuration
RUN echo "root:${ROOT_PASSWORD}" | chpasswd && \
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /run/sshd && \
    ssh-keygen -A

# 22 = SSH, 8080 = ZAP API/proxy (optional)
EXPOSE 22 8080

WORKDIR /root

CMD ["/bin/bash", "-c", "service ssh start && exec tail -f /dev/null"]
