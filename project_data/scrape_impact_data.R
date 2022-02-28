# this function retrieves impact data from scimagojr.com and cleans it

rm(list = ls())

if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

source('functions/f_get_impact_data2.R')

# retrieve impact data
impact_data <- get_impact_data2(c(1999:2019), sleep = 0.2)

# assign IDs
impact_data$id <- 1:nrow(impact_data)

# filter for journals that appear more than once
impact_data <- impact_data %>%
  group_by(title, year) %>%
  filter(rank == min(rank)) %>%
  ungroup()

# adjust ISSNs
impact_data$issn <- impact_data$issn %>% str_remove_all('[ -]')

# save retrieved data
saveRDS(impact_data, 'data/impact/impact_data_1999_2019_full.rds')

# select relevant columns
impact_data_small <- impact_data %>%
  select(id,
         year,
         rank,
         sourceid,
         issn,
         title,
         publisher,
         type,
         country,
         region,
         sjr,
         h_index,
         total_docs,
         total_refs,
         ref_per_doc = `ref_/_doc`)

# convert
impact_data_small <- impact_data_small %>%
  type.convert(dec = ',', as.is = T, na.strings = '-')

saveRDS(impact_data_small, 'data/impact/impact_data_1999_2019_small.rds')

# save tidy impact data
saveRDS(impact_data_small, 'data/impact/tidy/impact_data_full.rds')

# create dictionary
impact_data_id <- impact_data_small %>%
  select(id,
         year,
         issn,
         title)

# save
saveRDS(impact_data_id, 'data/impact/impact_data_1999_2019_id.rds')


