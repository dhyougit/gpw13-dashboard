rm(list = ls())
setwd("/Users/amitprasad/gpw13-dashboard/test-app") 

library(gdata)
library(dplyr)

# whs2 aligns the UN and WHO country naming conventions (with a preference for WHO conventions)
whs <- read.csv("data/whs2.csv", header = TRUE)
iso <- read.xls("data/CountryNameToISO3.xlsx", sheet = "in", perl = "/usr/bin/perl")

whs_iso <- merge(whs, iso, by.x = "country", by.y = "Country", all.x = TRUE)

## Use Code below to check for inconsistencies between UN and WHO country names
## table(whs_iso$country[is.na(whs_iso$Region)])
## sum(is.na(whs_iso$Region))

whs_iso <- whs_iso[, c(1, 57, 58, 56, 2:55)] %>%
            arrange(country, year)  
     
# Save file as csv
write.csv(whs_iso, file = "data/whs_iso.csv", row.names = FALSE)