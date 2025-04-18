# Layer 1: Debian Base (via Build-Script)
FROM debian:bullseye-slim AS base

# Layer 2–3: Grundlegende Umgebungsvariablen
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=C.UTF-8

# Layer 4: System-Updates & Abhängigkeiten installieren
RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        ca-certificates \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev && \
    rm -rf /var/lib/apt/lists/*

# Layer 5–7: Python-Download und -Definition
ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568 \
    PYTHON_VERSION=3.9.21 \
    PYTHON_SHA256=3126f59592c9b0d798584755f2bf7b081fa1ca35ce7a6fea980108d752a05bb1

# Layer 8: Python installieren
RUN set -eux; \
    curl -fsSLO --compressed "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"; \
    echo "${PYTHON_SHA256}  Python-${PYTHON_VERSION}.tgz" | sha256sum -c -; \
    tar -xzf "Python-${PYTHON_VERSION}.tgz"; \
    cd "Python-${PYTHON_VERSION}"; \
    ./configure --enable-optimizations; \
    make -j"$(nproc)"; \
    make altinstall; \
    ln -s /usr/local/bin/python3.9 /usr/local/bin/python3; \
    python3 --version

# Layer 9: Cleanup
RUN set -eux; \
    apt-get clean; \
    rm -rf /root/.cache

# Layer 10: Standardkommando (überschreibbar)
CMD ["python3"]

# Layer 11: Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Layer 12: Pakete installieren (z. B. Flask)
RUN apt-get update && apt-get install -y python3-pip && rm -rf /var/lib/apt/lists/*

# Layer 13: Python-Abhängigkeiten installieren
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Layer 14: Port freigeben (z. B. API auf 7877)
EXPOSE 7877/tcp

# Layer 15: Main-App starten
COPY . .
CMD ["python3", "nmcontroller.py"]
