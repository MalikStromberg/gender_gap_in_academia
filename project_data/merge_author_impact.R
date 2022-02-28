rm(list=ls())

# this script combines impact data and author data
# step 1: prepares authors data for join
# step 2: prepares impact data for join
# step 3: prepares dictionary to connect impact data and author data
# step 4: join

if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)


### step 1: author data prep ###

author_data <- readRDS('data/_final/data_author_labeled.rds') %>%
  # filter relevant years: impact data only for 1999 - 2019
  filter(year %in% c(1999:2019)) %>%
  # adjust issn
  mutate(issn = str_remove_all(issn, '[ -]'))

# author_data$issn <- author_data$issn %>% str_remove_all('[ -]')

# add index variable
author_data$idx <- 1:nrow(author_data)

# save reduced data set with impact relevant years
saveRDS(author_data, 'data/impact/tidy/author_data_full.rds')

# select relevant rows
author_data <- author_data %>%
  select(idx, year, container.title, issn)

issn <- author_data$issn
author_data <- author_data %>%
  separate(issn,
           into = c('issn_a', 'issn_b', 'issn_c', 'issn_d'),
           sep = ',')
# add issn
author_data$issn <- issn


### step 2: impact data prep ###

## impact data prep
impact_data <- readRDS('data/impact/impact_data_1999_2019_id.rds')

# extract issn
issn <- impact_data$issn

# split issn into sub parts since sometimes only parts are stored for author
# data
impact_data <- impact_data %>%
  separate(issn,
           into = c('issn_a', 'issn_b', 'issn_c'),
           sep = ',')
impact_data$issn <- issn
rm(issn)

### step 3: dictionary ###

# produce dictionary for joining both data sets

# try join by container title
matching <- left_join(
  author_data,
  impact_data,
  by = c('container.title' = 'title', 'year' = 'year')) %>% 
  filter(!is.na(id))

# extract indices that could not have been matched
matching_left <- author_data %>% filter(!(idx %in% matching$idx))

matching <- matching %>% select(id, idx)

# rm(author_data)

impact_data <- impact_data %>% select(-title)
matching_left <- matching_left %>% select(-container.title)

# try join by issn
temp <- left_join(matching_left,
                  impact_data,
                  by = c('issn' = 'issn', 'year' = 'year'))


temp <- temp %>% filter(!is.na(id))
matching_left <- matching_left %>% filter(!(idx %in% temp$idx))

temp <- temp %>% select(id, idx)

# extract indices that could not have been matched
matching_left <- matching_left %>% select(-issn)
impact_data <- impact_data %>% select(-issn)

# create dictionary
matching <- bind_rows(matching, temp)
rm(temp)

# try join by sub-parts of issn
for (i in c('_a', '_b', '_c', '_d')) {
  for (j in c('_a', '_b', '_c')) {
    join_cols = c('year', paste('issn', j, sep= ''))
    names(join_cols) <- c('year', paste('issn', i, sep= ''))
    
    temp <- matching_left[!is.na(matching_left[, paste('issn', i, sep= '')]), ]
    
    temp <- left_join(temp,
                      impact_data,
                      by = join_cols)
    temp <- temp %>% filter(!is.na(id)) %>% select(id, idx)
    matching_left <- matching_left %>%
      filter(!(idx %in% temp$idx))
    matching <- bind_rows(matching, temp)
  }
}

### step 4: join

# read data for final join
impact_data <- readRDS('data/impact/tidy/impact_data_full.rds')
author_data <- readRDS('data/impact/tidy/author_data_full.rds')

# extract names
names_author <- names(author_data)
names_impact <- names(impact_data)

# match names
names_double <- intersect(names_author, names_impact)

# adjust overlapping names
names_impact[names_impact %in% names_double] <-
  paste(names_impact[names_impact %in% names_double], '.imp', sep = '')

colnames(impact_data) <- names_impact

# join data by dictionary
author_labeled_impact <- left_join(author_data,
                                   matching,
                                   by = c('idx'))

author_labeled_impact <- left_join(author_labeled_impact,
                                   impact_data,
                                   by = c('id'))

# adjust variables
author_labeled_impact <- author_labeled_impact %>%
  mutate(ref_per_doc = as.numeric(str_replace_all(ref_per_doc, ',', '.')),
         container.title = str_replace_all(container.title, ' and ', ' & '))

# save final data set with impact data
saveRDS(author_labeled_impact,
        'data/_final/data_author_labeled_impact.rds')
