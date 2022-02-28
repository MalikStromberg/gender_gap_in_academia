# this script creates reduced data sets optimized for section I

rm(list=ls())

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("reshape2")) install.packages("reshape2")

library(tidyverse)
library(reshape2)

source('functions/f_get_fields.R')
source('functions/f_create_numerics.R')

fields <- get_fields(T)

data_ii <- list()

# read data
data <- readRDS('data/_final/data_author_labeled.rds')

# filter for years used in app
data <- data %>% filter(year >= 1960 & year <= 2020)

# number of publications per year data and research field
data_publications <- data %>%
  select(year, doi, any_of(fields)) %>%
  distinct()

# create all_fields indicator without gender studies
data_publications$all_fields <- ifelse(
  (data_publications$gender_studies) == 1 &
    (data_publications %>%
       select(any_of(fields)) %>%
       sapply(create_numerics) %>%
       rowSums() == 1),
  0,
  1
)

data_publications <- data_publications %>%
  mutate(all_fields = 1) %>%
  melt(id.vars = c('year', 'doi')) %>%
  filter(value == 1) %>%
  select(-value) %>%
  group_by(year = year, field = variable) %>%
  summarize(n_publications = n()) %>%
  ungroup()

data_ii$publications <- data_publications

rm(data_publications)

# number of journals per year
data_journals <- data %>%
  select(year, issn, any_of(fields)) %>%
  distinct()

# create all_fields indicator without gender studies
data_journals$all_fields <- ifelse(
  (data_journals$gender_studies) == 1 &
    (data_journals %>%
       select(any_of(fields)) %>%
       sapply(create_numerics) %>%
       rowSums() == 1),
  0,
  1
)

data_journals <- data_journals %>%
  melt(id.vars = c('year', 'issn')) %>%
  filter(value == 1) %>%
  select(-value) %>%
  group_by(year = year, field = variable) %>%
  summarize(n_journals = n()) %>%
  ungroup()

data_ii$journals <- data_journals
rm(data_journals)

# average number of authors per year
data_avg_authors <- data %>%
  select(year, doi, n_author, any_of(fields)) %>%
  group_by(year, doi) %>%
  slice_max(n_author) %>%
  ungroup() %>%
  select(-doi)

# create all_fields indicator without gender studies
data_avg_authors$all_fields <- ifelse(
  (data_avg_authors$gender_studies) == 1 &
    (data_avg_authors %>%
       select(any_of(fields)) %>%
       sapply(create_numerics) %>%
       rowSums() == 1),
  0,
  1
)

data_avg_authors <- data_avg_authors %>%
  melt(id.vars = c('year', 'n_author')) %>%
  filter(value == 1) %>%
  select(-value) %>%
  group_by(year = year, field = variable) %>%
  summarize(avg_authors = mean(n_author, na.rm = T),
            deviation = sd(n_author, na.rm = T)) %>%
  ungroup()

data_ii$avg_authors <- data_avg_authors
rm(data_avg_authors)

# read impact data
data <- readRDS('data/_final/data_author_labeled_impact.rds')

data_impact <- data %>%
  # here title.imp because it is the consistent variable at this point
  select(title.imp, h_index, any_of(fields)) %>%
  distinct()

# create all_fields indicator without gender studies
data_impact$all_fields <- ifelse(
  (data_impact$gender_studies) == 1 &
    (data_impact %>%
       select(any_of(fields)) %>%
       sapply(create_numerics) %>%
       rowSums() == 1),
  0,
  1
)

data_impact <- data_impact %>%
  melt(id.vars = c('title.imp', 'h_index')) %>%
  filter(value == 1) %>%
  select(-value, field = variable)

data_ii$impact <- data_impact
rm(data_impact)

saveRDS(data_ii, 'data/app/II.rds')
  
  
  
  
  
  
  



  