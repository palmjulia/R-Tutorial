# Kursmaterialen Tutorial R & fhircrackr

Kursdaten: Erlangen, 9. November 2022

In diesem GitHub Repository sind alle Materialien hinterlegt, die für das Tutorial **R & fhircrackr** benötigt werden.
Damit wir im Kurs nicht von systemspezifischen Problemen aufgehalten werden, wird R und RStudio innerhalb eines Docker Containers betrieben werden, in dem alle Kursteilnehmer die gleichen Bedingungen vorfinden. 

Daher ist vor dem Kurs eine kurze Vorbereitung notwendig, welche im folgenden beschrieben ist.

## Benötigte Ressourcen

- Eigenes Notebook (mit Internetzugang)

- Programme:
  - Docker Desktop/Docker Compose
  - Git (Nützlich, aber nicht zwingend notwendig)

## Vorbereitung

- Git Repository clonen: `git clone https://github.com/palmjulia/R-Tutorial.git` (Alternativ manuell herunterladen)
- Verzeichniswechsel ins lokale Repository `cd R-Tutorial/docker`
- Docker Image pullen mit `docker-compose pull` (Alternativ: Image selbst bauen, siehe README in R-Tutorial/docker)

## Test
Docker Container starten: `docker-compose up -d`.

Im Browser sollte jetzt nach einem Login unter der Adresse: [127.0.0.1:8787](http://127.0.0.1:8787) eine R-Studio-Oberfläche verfügbar sein.

Username: `rstudio`, Passwort: `pwd`.

Wenn das der Fall ist, kann der Docker Container mit `docker-compose down` wieder heruntergefahren werden.

Bei Problemen in der Vorbereitung bitte Kontakt auf nehmen mit  [Julia Palm](mailto:julia.palm@med.uni-jena.de) und/oder [Jonathan Mang](https://www.imi.med.fau.de/person/jonathan-mang/).

