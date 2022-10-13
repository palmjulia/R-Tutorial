#### Vorbereitung #####
#Environment bereinigen
rm(list=ls())


#### Working Directory ####
#aktuelles Working directory abrufen
getwd()

#anderes working directory setzen
setwd(dir = "data")
getwd()

#wieder zurück zum Ursprung
setwd("..")



#### Daten einlesen ####
#csv Datei einlesen
data1 <- read.csv(file = "data/data1.csv")
View(data1)

#tabstopp getrennte Daten einlesen
data2 <- read.table(file = "data/data2.txt", sep = "\t", header = TRUE)
View(data2)



####  Daten abspeichern ####
#data Verzeichnis listen
dir("data")

#Tabelle abspeichern
write.csv(x = data1, file = "data/my_data1.csv")

#data Verzeichnis listen
dir("data")

    

#### R-spezifische Speicherformate ####
#Einzelnes Objekt speichern
save(data1, file = "data/data1.RData")

#gesamten working space speichern
save.image(file = "data/alldata.RData")
#Einzelnes Objekt speichern
save(data1, file = "data/data1.RData")
#gesamten working space speichern
save.image(file = "data/alldata.RData")

#working space löschen
rm(list=ls())

#Daten wieder einlesen
load("data/data1.RData")
load("data/alldata.RData")


