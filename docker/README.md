# Docker Deployment

## Vorbereitung

```bash
cd docker

docker-compose build
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