
### 5a
b <- fhir_serialize(bundles)
saveRDS(b, "backup/backup5a.rds")

## 5b
b <- fhir_serialize(bundles)
saveRDS(b, "backup/backup5b.rds")

## 6a
b <- fhir_serialize(bundles)
saveRDS(b, "backup/backup6a.rds")

## 7a
b <- fhir_serialize(bundles)
saveRDS(b, "backup/backup7a.rds")

## 7b
b <- fhir_serialize(encounter_bundles)
saveRDS(b, "backup/backup7b.rds")
