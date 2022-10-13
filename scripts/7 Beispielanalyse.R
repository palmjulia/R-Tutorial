####################################################################
### Vorbereitung: Environment bereinigen, fhircrackr Paket laden ###
####################################################################

rm(list=ls())
library(fhircrackr)

##############################################
### Schritt 1: BMI der Patienten berechnen ###
##############################################

#### 1.a Observations für Körpergewicht und Körpergröße herunterladen ####

# Definiere den FHIR Search request 
# FHIR Server: https://mii-agiop-3p.life.uni-leipzig.de/fhir 
# LOINC Codes: 3142-7 (Gewicht), 8302-2 (Größe)




# Lade alle Bundles herunter


#backup falls Internetverbindung nicht geht: 
#bundles <- fhir_unserialize(readRDS("backup/backup7a.rds"))



#### 1.b Observation Ressourcen verflachen ####

# Erzeuge eine Table Description, die erstmal alle Datenelemente im format "compact" extrahiert 
# Du benötigst hier keine brackets




# Erzeuge eine Tabelle aus den Observations 






#### 1.c Daten vorbereiten ####

# Wandle die Spalte valueQuantity.value in numeric um




# Teile die Observations-Tabelle in zwei einzelne Tabellen auf
# Nenne diese Tabellen "weight" und "height"





# Führe den folgenden Code-Block aus um bei Mehrfachmessungen nur den 
# höchsten Messwert pro Patient für Körpergewicht/Körpergröße zu behalten
weight_reduced <- aggregate(x = weight, 
                  by = list(weight$subject.reference), 
                  FUN = max)

height_reduced <- aggregate(x = height, 
                            by = list(height$subject.reference), 
                            FUN = max)

# Behalte in beiden Tabellen nur die Spalten "subject.reference" und "valueQuantity.value"





#### 1.d BMI berechnen ####

# Merge die beiden eben erzeugten Tabellen anhand der subject.reference
# nenne das Ergebnis "bmi_data"





# Gib bmi_data bessere Spaltennamen
# z.B.: "patient", "height", "weight"





# Berechne den BMI speichere ihn als Variable "BMI" in der bmi_data Tabelle
# BMI = Gewicht [kg] / Größe [m]^2




# Schau dir den Datensatz an und entferne ggf. unrealistische Werte 





################################################################################
### Schritt 2: Herausfinden, wer Bluthochdruck als Komorbiditätsdiagnose hat ###
################################################################################

#### 2.a Encounter- und Condition-Ressourcen über POST herunterladen ####

# Führe die folgende Code-Zeile aus, um einen Komma-separierten String
# der relevanten Patienten-Ids zur Übergabe an den "patient" Suchparameter zu erzeugen
pat_ids <- paste(bmi_data$patient, collapse = ",")

# Erzeuge einen request und dazugehörigen body um Encounter und darin verlinkte Diagnosen herunterzuladen
# Übergib den string "pat_ids" an den Suchparameter "patient" und verwende den Suchparameter "_include" um die
# Condition Ressourcen einzuschließen

#request url



#body




# Übergib body und request an fhir_search() und lade die Bundles herunter


#backup falls Internetverbindung nicht geht: 
#encounter_bundles <- fhir_unserialize(readRDS("backup/backup7b.rds"))

#### 2.b Encounter Ressourcen verflachen ####

# Erzeuge eine Table Description für die Encounter
# Extrahiert werden sollen die folgenden zwei Elemente:
# diagnosis/condition/reference (genannt "diagnosis"), diagnosis/use/coding/code (genannt "diagnosis.use")
# Setze die Argumente "brackets" und "sep" auf einen geeigneten Wert





# Erzeuge eine Tabelle für die Encounter





# Verteile die multiplen Diagnosen im Encounter-Datensatz jeweils auf mehrere Zeilen 
# nenne das Ergebnis "molten_encounters"





# Entferne nun die Indices aus der eben erzeugten Tabelle





#behalte nur die Zeilen in molten_encounters, bei denen diagnosis.use den Wert "CM" annimmt





# Führe die folgende Zeile aus, um das "Condition/" in der Spalte "diagnosis" der molten_encounters Tabelle zu entfernen
molten_encounters$diagnosis <- sub("Condition/", "", molten_encounters$diagnosis)



#### 2.c Condition Ressourcen verflachen ####

# Erzeuge eine Table Description für die Conditions
# Extrahiert werden sollen die folgenden Elemente:
# id (genannt "id"), subject/reference (genannt "patient"), code/coding/code (genannt "code")





# Erzeuge eine Tabelle für die Conditions
# Nenne die Tabelle "condition_data"





# Führe die folgenden Code-Zeilen aus um condition_data nach zwei Kriterien zu filtern:
# 1) Die Diagnose stellt eine CM-Diagnose dar (=kommt im gefilterten molten_encounters vor)
# 2) Die Diagnose stellt einen Bluthochdruck dar (ICD I10-I15) 
condition_data <- condition_data[condition_data$id %in% molten_encounters$diagnosis &
                                   grepl("I10|I11|I12|I13|I14|I15", condition_data$code),]

# Führe die folgenden Code-Zeilen aus, um in bmi_data eine hypertension Variable zu erstellen,
# die den Wert "Yes" hat, wenn der entsprechende Patient in der condition_data Tabelle auftaucht
bmi_data$hypertension<- "No"
bmi_data[bmi_data$patient %in% condition_data$patient,]$hypertension <- "Yes"



####################################################################
### Schritt 3: Zusammenhang von BMI und Bluthochdruck darstellen ###
####################################################################

# Plot mit base R
boxplot(BMI ~ hypertension, data = bmi_data)

# Schönerer Plot mit Paket ggplot2
library(ggplot2)

ggplot(data = bmi_data, aes(x = hypertension, y = BMI, fill = hypertension )) +
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7, width = 0.25, height = 0) +
  theme(legend.position = "none") + 
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Relationship of BMI and Hypertension",
       x = "Hypertension as a comorbidity diagnosis")

# Statistischer Test
wilcox.test(BMI ~ hypertension, data = bmi_data, exact = FALSE)
