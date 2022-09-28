#### Subsetting ####
#Spalten auswählen
data1[, c(1,3)]
data1[, c("age", "id")]

#Einzelne Variable als Vektor aufrufen
data1$weight

#Zeilen auswählen
data1[c(1,3), ]
data1[data1$age > 40, ]






#### Faktoren ####
#unordered
gender <- factor(x = c("male", "female", "female"),
              levels = c("female", "male", "diverse"))
gender

#medium
dose <- factor(x = c("high", "high", "medium", "high"),
               levels = c("low", "medium", "high"),
               ordered = TRUE)
dose

#structure
str(dose)






#### Datentypen umwandeln ####

#Könnte ein Faktor sein
data2$eyecolor

#Geht nicht
as.numeric(data2$eyecolor)

#Geht
as.factor(data2$eyecolor)
data2$eyecolor <- as.factor(data2$eyecolor)

#Jetzt sind intern numerische Levels hinterlegt
as.numeric(data2$eyecolor)





#Mit id sollte man nicht rechnen können
class(data2$id)
mean(data2$id)

#Umwandlung in character
data1$id <- as.character(data1$id)
data2$id <- as.character(data2$id)

#Jetzt lässt R nicht mehr rechnen
data1$id
mean(data1$id)




#### Neue Variablen erstellen ####
#Variable mit 0 initialisieren
data2$blueEyes <- 0
data2

#An den richtigen Stellen 1 einsetzen
data2[data2$eyecolor=="blue",]
data2[data2$eyecolor=="blue",]$blueEyes <- 1
data2

#### Datensätze mergen ####
#Inner join
merge(x = data1, 
      y = data2,
      by = "id",
      all = FALSE)

#Full join
merge(x = data1, 
      y = data2,
      by = "id",
      all = TRUE)

#Left join
merge(x = data1, 
      y = data2,
      by = "id",
      all.x = TRUE)




#### Vektorrechnung in der Variablenerstellung ####
#Vollen Datensatz erstellen
data <- merge(x = data1, 
              y = data2,
              by = "id",
              all = TRUE)

#BMI berechnen
data$BMI <- data$weight/(data$height/100)^2
data
