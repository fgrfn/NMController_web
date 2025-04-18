# Verwende das offizielle Python-Image von Docker Hub
FROM python:3.9-slim

# Erstellung eines Work Dir
WORKDIR /usr/src/app

# Git clone der offiziellen Repository
RUN apt-get update && apt-get install -y git \
    && git clone https://github.com/NMminer1024/NMController_web . \
    && apt-get remove -y git && apt-get autoremove -y

# Installation der Abhängigkeiten
RUN pip install --no-cache-dir -r requirements.txt

# Freigabe des WebUI Port 7887
EXPOSE 7877

# start des Controllers
CMD ["python", "nmcontroller.py"]
