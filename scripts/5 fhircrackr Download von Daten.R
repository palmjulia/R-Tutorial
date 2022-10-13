#### Vorbereitung #####
#Environment bereinigen
rm(list=ls())




#### Intro ####

#erste Installation (für den Kurs nicht nötig)
#install.packages("fhircrackr")

#Paket laden (1x pro R Session)
library(fhircrackr)

#Vignetten anschauen
??fhircrackr






#### Exkurs: S4 Klassen ####
#Beispiel fhir_url
?fhir_url

#Konstruktor aufrufen
request <- fhir_url(url = "https://mii-agiop-3p.life.uni-leipzig.de/fhir",
                    resource = "Patient",
                    parameters = c(gender = "female",
                                   birthdate = "ge1990"))

#Objekt inspizieren
request
class(request)
str(request)




#### Ressourcen herunterladen per GET ####
#Download
bundles <- fhir_search(request = request,
                       max_bundles = 2)


#backup falls Internetverbindung nicht geht: 
#bundles <- fhir_unserialize(readRDS("backup/backup5a.rds"))

#Ergebnis
bundles

#einzelnes Bundle
bundles[[1]]
cat(toString(bundles[[1]]))






#### Ressourcen herunterladen per POST ####
request <- fhir_url(url = "https://mii-agiop-3p.life.uni-leipzig.de/fhir",
                    resource = "Patient")

#body definieren
body <- fhir_body(content = list(gender = "female",
                                 birthdate = "ge1990"))
body

#download
bundles <- fhir_search(request = request,
                       body = body,
                       max_bundles = 2)


#backup falls Internetverbindung nicht geht: 
#bundles <- fhir_unserialize(readRDS("backup/backup5b.rds"))



#### Umgang mit HTTP-Fehlern ####
#Fehlende Authentifizierung
fhir_search("https://mii-agiop-polar.life.uni-leipzig.de/fhir/Patient")

#Fehler aufrufen
cat(fhir_recent_http_error())

#Falscher Suchparameter
fhir_search("https://mii-agiop-3p.life.uni-leipzig.de/fhir/Observation?gender=female",
            log_errors = "Observation_error.txt")





#### Bundles speichern und Laden ####
#als xml
fhir_save(bundles = bundles, directory = "PatientBundles")

#laden
rm(list = ls())
bundles <- fhir_load(directory = "PatientBundles")
bundles

#als RData
#Serialize
bundles_serialized <- fhir_serialize(bundles)
bundles_serialized

#save
save(bundles_serialized, file = "PatientBundles/bundles.RData")

#load
rm(list=ls())
load("PatientBundles/bundles.RData")
bundles <- fhir_unserialize(bundles_serialized)
bundles


