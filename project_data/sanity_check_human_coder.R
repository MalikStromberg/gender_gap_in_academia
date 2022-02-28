# this script compares human coding and NB-labeling

library(tidyverse)

data <- readRDS('data/name/sanity_checks/sanity_check2.rds')

table(data$human == data$algorithm)
# 75%

data_known <- data %>% filter(human != 'U' & algorithm != 'U')
table(data_known$human == data_known$algorithm)

# 94.7%