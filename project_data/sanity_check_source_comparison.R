rm(list=ls())

# make sure that there is an authentification key in:
# 'authentication/gender_api_authentication.R'

# CAUTION: Evaluating this script may be expensive. As a precaution sure is
# set to FALSE here. If you are sure you want to get new gender information,
# you have a valid API-Key, and enough tokens left, set sure to TRUE.

sure <- FALSE

###############################################################################

if (!require("caret")) install.packages("caret")

library(tidyverse)
library(caret)
set.seed(42)

# read data and select relevant columns and observations
data <- readRDS('data/_final/data_author_labeled.rds') %>%
  select(gname, label_6, label_7, label_75, accuracy, label_api_6) %>%
  filter(!is.na(label_6) & label_6 != 'U' & is.na(label_api_6)) %>%
  distinct()

# draw random sample
data_sample <- data %>% sample_n(5000) %>% select(-label_api_6)

# extract names
names <- data_sample$gname

if (sure) {
  ## get authentication key
  source('authentication/gender_api_authentication.R')
  
  #initialization
  names_labels <- c()
  response_list <- list()
  
  # request name data
  for (i in 0:((length(names) %/% 100))) {
    # only 100 names per request allowed
    idx <- (i * 100 + 1):min(length(names), i * 100 + 100)
    names_string <- names[idx] %>% paste(collapse = ';')
    res_gender <- httr::GET(url = 'https://gender-api.com/get?',
                            query = list(
                              name = names_string,
                              key = Sys.getenv('gender_api_key')
                            ))
    content_gender <- httr::content(res_gender, as = 'text') %>%
      jsonlite::fromJSON()
    
    response_list <- append(response_list, content_gender)
    names_labels <- bind_rows(names_labels, content_gender$result)
    # give server time to breath
    Sys.sleep(.5)
  }
  
  # save data
  saveRDS(response_list, 'data/name/sanity_checks/api_sanity_check_list.rds')
  saveRDS(names_labels, 'data/name/sanity_checks/api_sanity_check.rds')
}

# read data
names_labels <- readRDS('data/name/sanity_checks/api_sanity_check.rds')

# combine data
data_sample <- left_join(data_sample, names_labels,
                         by = c('gname' = 'name_sanitized')) 

# labeling
data_sample$gender <- data_sample$gender %>%
  str_sub(1, 1) %>%
  str_to_upper()

data_sample$label_api <- ifelse(data_sample$gender == 'U',
                                'U',
                                ifelse(data_sample$accuracy.y > 60,
                                       data_sample$gender,
                                       'D'))

# save data
saveRDS(data_sample, 'data/name/sanity_checks/api_sanity_check_result.rds')

# filter for unknowns
data_reduced <- data_sample %>% filter(label_api != 'U')

# create tables
table(data_reduced$label_6 == data_reduced$label_api) %>% prop.table()

data_reduced_female <- data_reduced %>% filter(label_6 == 'F')
data_reduced_male <- data_reduced %>% filter(label_6 == 'M')

table(data_reduced_female$label_6 == data_reduced_female$label_api) %>%
  prop.table()
table(data_reduced_male$label_6 == data_reduced_male$label_api) %>%
  prop.table()

data_reduced$label_api %>% table()
data_reduced$label_6 %>% table()

caret::confusionMatrix(as.factor(as.character(data_reduced$label_6)),
                       as.factor(data_reduced$label_api),
                       dnn = c('NB', 'API'))




