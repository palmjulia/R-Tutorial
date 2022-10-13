# Docker Deployment

## Vorbereitung

```bash
cd docker

docker-compose pull
```

### Advanced

```bash
## In der docker-compose das image auskommentieren und das build-Kommando einkommentieren, dann:
# docker-compose build

## ... oder händisch selber bauen:
# docker build -t joundso/rstudio:latest .
```

## Ausführen des RStudio Containers

```bash
cd docker

docker-compose up -d
```

RStudio ist im Browser unter der Adresse: [127.0.0.1:8787](http://127.0.0.1:8787) verfügbar.
Username: `rstudio`, Passwort: `pwd` (oder was auch immer im [docker-compose](docker-compose.yaml) file spezifiziert ist).

## Beenden von RStudio

```bash
# cd docker

docker-compose down

# cd ..
```
