# Offizielles Python-Image mit 3.9
FROM python:3.9-slim

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Abhängigkeiten installieren
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Projektdateien kopieren
COPY . .

# Exponierten Port für API
EXPOSE 7877

# Startkommando
CMD ["python", "nmcontroller.py"]
