# this script creates reduced data sets optimized for section I

rm(list=ls())

if (!require("tidyverse")) install.packages("tidyverse")

library(tidyverse)

source('functions/f_get_fields.R')

data_i <- list()

# read data
data <- readRDS('data/_final/data_author_labeled.rds')

# filter for years used in app
data <- data %>% filter(year >= 1960 & year <= 2020)

# extract number of articles
data_i$n_articles <- data$doi %>%
  unique() %>%
  length() %>%
  formatC(big.mark = ',')

# extract number of journals
data_i$n_journals <- data$container.title %>%
  unique() %>%
  length() %>%
  formatC(big.mark = ',')

# extract number of successfully labeled given names
# would work for label_7 and labe_75 accordingly with same results
data_i$n_gnames <- data %>%
  filter(label_6 != 'U' & !is.na(label_6)) %>%
  select(gname) %>%
  unique() %>%
  nrow() %>% 
  formatC(big.mark = ',')

# extract years used in app
data_i$years <- c(min(data$year):max(data$year))

# extract number of research fields
data_i$n_fields <- length(get_fields(T))

saveRDS(data_i, 'data/app/I.rds')
