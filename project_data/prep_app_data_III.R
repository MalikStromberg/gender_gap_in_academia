# this script creates reduced data sets optimized for section III of the app
# it is based on the data set for section V

rm(list=ls())

#if (!require("readr")) install.packages("readr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tibble")) install.packages("tibble")
if (!require("tidyr")) install.packages("tidyr")

#library(readr)
library(dplyr)
library(tibble)
library(tidyr)

threshold <- c(6, 7, 75)

for (j in 1:3) {
  original <- readRDS(paste0("data/app/V_", threshold[j], ".rds"))
  
  # source prepared data frame with 'all_fields'
  all_fields_df <- readRDS(paste0("data/app/V_all_", threshold[j], ".rds"))
  names(all_fields_df)[names(all_fields_df) == "percentage_round"] <- "percentage"
  # all_fields_df$gender <- as.factor(all_fields_df$gender)
  
  # remove unwanted cols
  data <- original
  data <-
    data %>% select(-11)  # Remove female-male ratio
  
  # rounding 
  data$perc.m <- round(data$perc.m*100, digits = 2)
  data$perc.f <- round(data$perc.f*100, digits = 2)
  data$perc.u <- round(data$perc.u*100, digits = 2)
  data$perc.d <- round(data$perc.d*100, digits = 2)
  data_prep <- data
  
  # gather data (percentage)
  data <-
    data %>% gather(perc.m,
                    perc.f,
                    perc.u,
                    perc.d,
                    key = "gender",
                    value = "percentage")
  
  data$gender <- data$gender %>% gsub(pattern = "perc.",
                                      replacement = "")  # remove "perc."
  # remove unwanted cols
  data <- 
    data %>% select(c(-3, -4, -5, -6))
  
  # Get data (absolute numbers)
  abs_nr <- 
    data_prep %>% gather(number.m, 
                         number.f,
                         number.u,
                         number.d,
                         key = "gender",
                         value = "nr_publications")
  nr_publications <- abs_nr$nr_publications
  
  # cbind data set
  data <- data %>% cbind(nr_publications)
  
  # Add data frame containing all_fields
  data <- data %>% bind_rows(all_fields_df)
  
  # replace abbreviation
  data$gender <- data$gender %>% str_replace_all(c("m" = "Male",
                                                   "f" = "Female",
                                                   "u" = "Unknown",
                                                   "d" = "Unisex Names"))
  
  
  
  # Relevel group factor
  data$gender <- factor(
    data$gender,                 
    levels = c("Male", "Female", "Unknown", "Unisex Names"))
  
  # remove dummy 
  remove(abs_nr, data_prep, original)
  
  saveRDS(data, file = paste0("data/app/III_", threshold[j], ".rds"))
}
# remove(threshold)
