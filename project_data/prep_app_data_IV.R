rm(list=ls())

# Recall 
#if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tibble")) install.packages("tibble")
if (!require("tidyr")) install.packages("tidyr")

library(dplyr)
library(tibble)
library(tidyr)

source('functions/f_smart_round.R')

# the following code summarizes the data for section IV

threshold <- c(6, 7, 75)

for (j in 1:3) {
  # source data V which is used as base data here
  original <- readRDS(paste0("data/app/V_", threshold[j], ".rds"))
  
  # source prepared data frame with 'all_fields'
  all_fields_df <- readRDS(paste0("data/app/V_all_", threshold[j], ".rds"))
  
  # Remove unwanted cols
  data_loop <- original
  data_loop <-
    data_loop %>% select(-11)  # just keep percentages
  
  data_prep <- data_loop  # create dummy df
  
  # Add col for percentage rounded
  data_loop <- data_loop %>% cbind(
    "rounded.m" = NA,
    "rounded.f" = NA,
    "rounded.u" = NA,
    "rounded.d" = NA
  )
  
  # Add rounded values
  for (i in 1:nrow(data_loop)) {
    x <-
      c(data_loop$perc.m[i],
        data_loop$perc.f[i],
        data_loop$perc.u[i],
        data_loop$perc.d[i])
    
    data_loop$rounded.m[i] <- smart_round(x * 100)[1]
    data_loop$rounded.f[i] <- smart_round(x * 100)[2]
    data_loop$rounded.u[i] <- smart_round(x * 100)[3]
    data_loop$rounded.d[i] <- smart_round(x * 100)[4]
  }
  
  # Remove percentage cols (just need absolute numbers as created in for loop)
  data_loop <- data_loop %>% select(-(3:10))
  
  # Gather data
  data_loop <-
    data_loop %>% gather(rounded.m,
                    rounded.f,
                    rounded.u,
                    rounded.d,
                    key = "gender",
                    value = "percentage_round")
  # Use dummy
  abs_nr <- 
    data_prep %>% gather(number.m, 
                         number.f,
                         number.u,
                         number.d,
                         key = "gender",
                         value = "nr_publications")
  nr_publications <- abs_nr$nr_publications
  
  # cbind data set
  data_loop <- data_loop %>% cbind(nr_publications)
  
  # Cleaning: remove "rounded."
  data_loop$gender <- data_loop$gender %>% gsub(pattern = "rounded.",
                                      replacement = "")  
  
  # Add data frame containing all_fields
  data_loop <- data_loop %>% bind_rows(all_fields_df)
  
  # Relevel Groups
  # data_loop$gender <- factor(data_loop$gender,
  #                       levels = c("m", "f", "u", "d"))
  # Save data 
  saveRDS(data_loop, file = paste0("data/app/IV_", threshold[j], ".rds"))
}

remove(threshold)