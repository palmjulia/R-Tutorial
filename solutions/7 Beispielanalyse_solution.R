###############################################
### Vorbereitung: Lade das fhircrackr Paket ###
###############################################

library(fhircrackr)

##############################################
### Schritt 1: BMI der Patienten berechnen ###
##############################################

#### 1.a Observations für Körpergewicht und Körpergröße herunterladen ####

# Definiere den FHIR Search request 
# FHIR Server: https://mii-agiop-3p.life.uni-leipzig.de/fhir 
# LOINC Codes: 3142-7 (Gewicht), 8302-2 (Größe)

request <- fhir_url(url = "https://mii-agiop-3p.life.uni-leipzig.de/fhir",
                    resource = "Observation",
                    parameters = c("code" = "http://loinc.org|3142-7, http://loinc.org|8302-2")
)

# Lade alle Bundles herunter
bundles <- fhir_search(request = request)




#### 1.b Observation Ressourcen verflachen ####

# Erzeuge eine Table Description, die erstmal alle Datenelemente im format "compact" extrahiert 
# Du benötigst hier keine brackets
observations <- fhir_table_description(resource = "Observation")

# Erzeuge eine Tabelle aus den Observations 
obs_table <- fhir_crack(bundles = bundles, design = observations)




#### 1.c Daten vorbereiten ####

# Wandle die Spalte valueQuantity.value in numeric um
obs_table$valueQuantity.value <- as.numeric(obs_table$valueQuantity.value)

# Teile die Observations-Tabelle in zwei einzelne Tabellen auf
# Eine für Körpergewicht, eine für Körpergröße, nenne sie "weight" und "height"
weight <- obs_table[obs_table$code.coding.code=="3142-7",] 
height <- obs_table[obs_table$code.coding.code=="8302-2",] 

# Führe den folgenden Code-Block aus um bei Mehrfachmessungen nur den 
# höchsten Messwert pro Patient für Körpergewicht/Körpergröße zu behalten
weight_reduced <- aggregate(x = weight, 
                  by = list(weight$subject.reference), 
                  FUN = max)

height_reduced <- aggregate(x = height, 
                            by = list(height$subject.reference), 
                            FUN = max)

# Behalte in beiden Tabellen nur die Spalten "subject.reference" und "valueQuantity.value"
weight_reduced <- weight_reduced[,c("subject.reference","valueQuantity.value")]
height_reduced <- height_reduced[,c("subject.reference","valueQuantity.value")]

#### 1.d BMI berechnen ####

# Merge die beiden eben erzeugten Tabellen anhand der subject.reference, nenne das Ergebnis bmi_data
bmi_data <- merge(x = height_reduced,
                  y = weight_reduced,
                  by = "subject.reference")

# Gib bmi_data bessere Spaltennamen
# z.B.: "patient", "height", "weight"
colnames(bmi_data) <- c("patient", "height", "weight")

# Berechne den BMI speichere ihn als Variable "BMI" in der bmi_data Tabelle
# BMI = Gewicht [kg] / Größe [m]^2
bmi_data$BMI <- bmi_data$weight/(bmi_data$height/100)^2

# Schau dir den Datensatz an und entferne ggf. unrealistische Werte 
View(bmi_data)
bmi_data<- bmi_data[bmi_data$BMI < 150,]


################################################################################
### Schritt 2: Herausfinden, wer Bluthochdruck als Komorbiditätsdiagnose hat ###
################################################################################

#### 2.a Encounter- und Condition-Ressourcen über POST herunterladen ####

# Führe die folgende Code-Zeile aus, um einen Komma-separierten String
# der relevanten Patienten-Ids zur Übergabe an den "patient" Suchparameter zu erzeugen
pat_ids <- paste(bmi_data$patient, collapse = ",")

# Erzeuge einen request und dazugehörigen body um Encounter und darin verlinkte Diagnosen herunterzuladen
# Übergib den string "pat_ids" an den Suchparameter "patient" und verwende desn Suchparameter "_include" um die
# Condition Ressourcen einzuschließen

#request url
request <- fhir_url(url = "https://mii-agiop-3p.life.uni-leipzig.de/fhir",
                    resource = "Encounter")

#body
body <- fhir_body(content = list("patient" = pat_ids,
                                 "_include" = "Encounter:diagnosis"))

# Übergib body und request an fhir_search() und lade die Bundles herunter
encounter_bundles <- fhir_search(request = request, body = body)

#### 2.b Encounter Ressourcen verflachen ####

# Erzeuge eine Table Description für die Encounter
# Extrahiert werden sollen die folgenden zwei Elemente:
# diagnosis/condition/reference (genannt "diagnosis"), diagnosis/use/coding/code (genannt "diagnosis.use")
# Setze die Argumente "brackets" und "sep" auf einen geeigneten Wert
encounters <- fhir_table_description(resource = "Encounter",
                                     cols = c(
                                       diagnosis = "diagnosis/condition/reference",
                                       diagnosis.use = "diagnosis/use/coding/code"), 
                                     brackets = c("[", "]"), 
                                     sep = " $ "
)

# Erzeuge eine Tabelle für die Encounter
encounter_data <- fhir_crack(encounter_bundles, design = encounters)


# Verteile die multiplen Diagnosen im Encounter-Datensatz jeweils auf mehrere Zeilen 
# nenne das Ergebnis "molten_encounters"
molten_encounters <- fhir_melt(indexed_data_frame = encounter_data, 
                               columns = c("diagnosis", "diagnosis.use"),
                               brackets = c("[", "]"),
                               sep = " $ ",
                               all_columns = T)

# Entferne nun die Indices aus der eben erzeugten Tabelle
molten_encounters <- fhir_rm_indices(molten_encounters, brackets = c("[", "]"))

#behalte nur die Zeilen in molten_encounters, bei denen diagnosis.use den Wert "CM" annimmt
molten_encounters <- molten_encounters[molten_encounters$diagnosis.use=="CM",]

# Führe die folgende Zeile aus, um das "Condition/" in der Spalte "diagnosis" der molten_encounters Tabelle zu entfernen
molten_encounters$diagnosis <- sub("Condition/", "", molten_encounters$diagnosis)



#### 2.c Condition Ressourcen verflachen ####

# Erzeuge eine Table Description für die Conditions
# Extrahiert werden sollen die folgenden Elemente:
# id (genannt "id"), subject/reference (genannt "patient"), code/coding/code (genannt "code")
conditions <- fhir_table_description(resource = "Condition",
                                     cols = c(
                                       id = "id",
                                       patient = "subject/reference",
                                       code = "code/coding/code")
)
# Erzeuge eine Tabelle für die Conditions
# Nenne die Tabelle "condition_data"
condition_data <- fhir_crack(encounter_bundles, design = conditions)


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
