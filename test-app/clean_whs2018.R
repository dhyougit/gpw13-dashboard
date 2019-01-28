rm(list = ls())
setwd("/Users/amitprasad/gpw13-dashboard/test-app") 

library(ggplot2)
library(DT)
library(readxl)
library(tidyverse) 
library(dplyr)
library(stringr)
library(reshape2)

whs <- read_excel("WHS_combined2016to2018.xls", sheet = "2018_clean",  skip = 1)

names(whs) <- c("country", "pop_2016", "le_2016", "hale_2016", "chepc_2015", "chegdp_2015", "mmr_2015",
                "sba_2017", "u5mr_2016", "nmr_2016", "hiv_2016", "tb_2016", "malaria_2016", "hepb_2015",
                "ntd_2016", "ncd_2016", "suicide_2016", "alcohol_2016", "traffic_2013", "famplan_2017", "adolescent_2016",
                "uhc_2015", "cat10_2015", "cat25_2015", "pollution_2016", "wash_2016", "poisoning_2016", 
                "tobaccom_2016", "tobaccof_2016", "dtp3_2016", "measles_2016", "pcv3_2016", "odapc_2016", 
                "doctors_2016", "nurses_2016", "dentists_2016", "pharmacists_2016", "ihr_2017", "gghed_2015",
                "stunting_2016", "wasting_2016", "overweight_2016", "water_2015", "sanitation_2015", 
                "cleanfuel_2016", "pm25_2016", "disasters_2016", "homicide_2016", "conflicts_2016", "cod_2016")

for (i in 2:length(names(whs))) {
  whs[[i]] <- str_replace(whs[[i]], "<", "")
  whs[[i]] <- str_replace(whs[[i]], "-", NA_character_)
  whs[[i]] <- as.numeric(whs[[i]])
}

whs %>%
  gather(indicator, value, -country) %>%
  separate(indicator, into = c("indicator", "year"), sep="_", remove=TRUE) %>%
  spread(indicator, value)


