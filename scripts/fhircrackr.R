#### Intro ####

#erste Installation (für den Kurs nicht nötig)
#install.packages("fhircrackr")

#Paket laden (1x pro R Session)
library(fhircrackr)

#Vignetten anschauen
browseVignettes(package = "fhircrackr")


#### Exkurs: S4 Klassen ####
#Hilfe aufrufen
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


#### Table Description ####
#Definition
pat_desc <- fhir_table_description(resource = "Patient")
pat_desc

#cracken
patients <- fhir_crack(bundles = bundles, design = pat_desc)
View(patients)


#### Spaltenbeschreibung ####
#selbstgewählte Spaltennamen
pat_desc <- fhir_table_description(resource = "Patient",
                                   cols = c(Stadt = "address/city",
                                            Geschlecht = "gender"))
pat_desc

#cracken
patients <- fhir_crack(bundles = bundles, design = pat_desc)
View(patients)

#automatische Spaltennamen
pat_desc <- fhir_table_description(resource = "Patient",
                                   cols = c("address/city",
                                            "gender"))
pat_desc

#cracken
patients <- fhir_crack(bundles = bundles, design = pat_desc)
View(patients)


#### Multiple Elemente ####
#Beispielbundle verfügbar machen
bundles <- fhir_unserialize(example_bundles1)
cat(toString(bundles[[1]]))

#ohne Indizes
pat_desc <- fhir_table_description(resource = "Patient",
                                   sep = " | ")

patients_compact <- fhir_crack(bundles = bundles,design = pat_desc)

View(patients_compact)

#Mit Indizes
pat_desc <- fhir_table_description(resource = "Patient",
                                   sep = " | ",
                                   brackets = c("[", "]"))

patients_compact <- fhir_crack(bundles = bundles, design = pat_desc)

View(patients_compact)



#### Wide format ####
pat_desc <- fhir_table_description(resource = "Patient",
                                   brackets = c("[", "]"),
                                   format = "wide")

patients_wide <- fhir_crack(bundles = bundles, design = pat_desc)

View(patients)


#### Melting ####
#melt names
patients_long <- fhir_melt(patients_compact, 
                           columns = "name.given",
                           brackets = c("[", "]"),
                           sep = " | ",
                           all_columns = T)
View(patients_long)

### melt address
#columns to expand
cols <- fhir_common_columns(patients_long, column_names_prefix = "address")
cols

#melt
patients_long <- fhir_melt(patients_long, 
                           columns = cols,
                           brackets = c("[", "]"),
                           sep = " | ",
                           all_columns = TRUE)
View(patients_long)

#remove indices
fhir_rm_indices(patients_long, brackets = c("[", "]"))
View(patients_long)


#### Weitere Optionen in der Table Description ####
#Example Bundle mit verschiedenen Attributen
bundles <- fhir_unserialize(example_bundles4)
cat(toString(bundles[[1]]))

#Table description
medication_desc <- fhir_table_description(resource = "Medication",
                                          keep_attr = TRUE)

#crack
meds <- fhir_crack(bundles = bundles, design = medication_desc)
View(meds)


#### Mehr als ein Ressourcentyp ####


