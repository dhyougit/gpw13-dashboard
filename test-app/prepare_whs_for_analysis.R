rm(list = ls())
setwd("/Users/amitprasad/gpw13-dashboard/test-app") 

# Loading libraries
library(readxl)
library(stringr)
library(tidyverse)
library(dplyr)

# Load datasets
whs2018 <- read_excel("data/WHS_combined2016to2018.xlsx", sheet = "2018_clean",  skip = 1)
whs2017 <- read_excel("data/WHS_combined2016to2018.xlsx", sheet = "2017_clean",  skip = 1)
whs2016 <- read_excel("data/WHS_combined2016to2018.xlsx", sheet = "2016_clean",  skip = 1)

###                   ###
### HELPER FUNCTIONS  ###
###                   ###

# Function to clean and reshape dataset
clean_reshape <- function(whs) {
  for (i in 2:length(names(whs))) {
    whs[[i]] <- str_replace(whs[[i]], "<", "")
    whs[[i]] <- str_replace(whs[[i]], "-", NA_character_)
    whs[[i]] <- as.numeric(whs[[i]])
  }
  whs <- whs %>%
    gather(indicator, value, -country) %>%
    separate(indicator, into = c("indicator", "year"), sep="_", remove=TRUE) %>% 
    spread(indicator, value)
  return(whs)
}

# Function to add rows for missing years
add_rows <- function(whs, year) {
  for (c in unique(whs$country)) {
    for (y in year) {
      new.row <- head(whs[NA,], 1)
      new.row[c('country', 'year')] <- list(country=c, year=y)
      whs <- rbind(whs, new.row) 
    }
  }
  return(whs)
}

# Function to replace NA values for previous years where available
replace_NA <- function(whs1, whs2) {
  for (col in names(whs1)) {
    for (row in 1:nrow(whs1)) {
      if (is.na(whs1[row, col])) {
        whs1[row, col] <- whs2[row, col]
      }
    }
  }
  return(whs1)
}


###                 ###
### RENAME COLUMNS  ###
###                 ###
names(whs2018) <- c("country", "pop_2016", "lem_2016", "lef_2016", "le_2016", "hale_2016", "chepc_2015", "chegdp_2015", "mmr_2015",
                    "sba_2017", "u5mr_2016", "nmr_2016", "hiv_2016", "tb_2016", "malaria_2016", "hepbag_2015",
                    "ntd_2016", "ncd_2016", "suicide_2016", "alcohol_2016", "traffic_2013", "famplan_2017", "adolescent_2016",
                    "uhc_2015", "cat10_2015", "cat25_2015", "pollution_2016", "wash_2016", "poisoning_2016", 
                    "tobaccom_2016", "tobaccof_2016", "dtp3_2016", "measles_2016", "pcv3_2016", "odapc_2016", 
                    "doctors_2016", "nurses_2016", "dentists_2016", "pharmacists_2016", "ihr_2017", "gghed_2015",
                    "stunting_2016", "wasting_2016", "overweight_2016", "water_2015", "sanitation_2015", 
                    "cleanfuel_2016", "pm25_2016", "disasters_2016", "homicide_2016", "conflicts_2016", "cod_2016")

names(whs2017) <- c("country", "pop_2015", "lem_2015", "lef_2015", "le_2015", "hale_2015", "mmr_2015", "sba_2016", "u5mr_2015", "nmr_2015", 
                    "hiv_2015", "tb_2015", "malaria_2015", "hepb_2015", "ntd_2015", "ncd_2015", "suicide_2015", "alcohol_2016", "traffic_2013", 
                    "famplan_2015", "adolescent_2014", "pollution_2012", "wash_2012", "poisoning_2015", "tobaccom_2015", "tobaccof_2015", 
                    "dtp3_2015", "odapc_2014", "shp_2015", "ihr_2016", "gghed_2014", "stunting_2016", "wasting_2016", "overweight_2016", 
                    "water_2015", "sanitation_2015", "cleanfuel_2014", "pm25_2014", "disasters_2015", "homicide_2015", "conflicts_2015", "cod_2015")

names(whs2016) <- c("country", "pop_2015", "lem_2015", "lef_2015", "le_2015", "hale_2015", "mmr_2015", "sba_2014", "u5mr_2015", "nmr_2015", 
                    "hiv_2014", "tb_2014", "malaria_2013", "hepb_2014", "ntd_2014", "ncd_2012", "suicide_2012", "alcohol_2015", "traffic_2013", 
                    "famplan_2015", "adolescent_2015", "pollution_2012", "wash_2012", "poisoning_2012", "tobaccom_2015", "tobaccof_2015", 
                    "shp_2013", "ihr_2015", "stunting_2015", "wasting_2015", "overweight_2015", 
                    "water_2015", "sanitation_2015", "cleanfuel_2014", "pm25_2014", "disasters_2015", "homicide_2012", "conflicts_2015")

###                   ###
### PREPARE DATASETS  ###
###                   ###
# Clean and reshape dataframes
whs2018 <- clean_reshape(whs2018)
whs2017 <- clean_reshape(whs2017)
whs2016 <- clean_reshape(whs2016)

# Replace NA values for whs2017 with available values for whs2016
whs2016[c("dtp3", "odapc", "gghed", "cod")] <- NA
whs2016 <- add_rows(whs2016, "2016")
whs2016 <- whs2016[with(whs2016, order(country, year)),]

whs2017 <- replace_NA(whs2017, whs2016)

# Replace NA values for whs2018 with available values for whs2017
whs2017[c("chepc", "chegdp", "uhc", "cat10", "cat25", "hepbag", "measles", "pcv3", "doctors", "nurses", "dentists", "pharmacists")] <- NA
whs2017 <- add_rows(whs2017, c("2017"))
whs2017 <- whs2017[with(whs2017, order(country, year)),]

whs2018[c("hepb", "shp")] <- NA
whs2018 <- add_rows(whs2018, c("2012", "2014"))
whs2018 <- whs2018[with(whs2018, order(country, year)),]
whs2018 <- replace_NA(whs2018, whs2017)

# Save file as csv
write.csv(whs2018, file = "data/whs.csv", row.names = FALSE)