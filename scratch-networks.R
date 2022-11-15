library(tidyverse)
library(spdep)

gang.matrix <- read_csv("https://raw.githubusercontent.com/crd230/data/master/seattle_gang_tracts.csv")
gang.matrix <- gang.matrix %>% 
  dplyr::select(-X1)
  
spdep::mat2listw(as.matrix(gang.matrix))
  