rm(list=ls())

# this script retrieves labeling for unknown names from gender-api

# make sure that there is an authentification key in:
# '/authentication/gender_api_authentication.R'

# CAUTION: Evaluating this script may be expensive. As a precaution sure is
# set to FALSE here. If you are sure you want to get new gender information,
# you have a valid API-Key, and enough tokens left, set sure to TRUE.

sure <- FALSE

###############################################################################
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("httr")) install.packages("httr")
if (!require("jsonlite")) install.packages("jasonlite")

library(tidyverse)

# read data labeled by naive bayes
data <- readRDS('data/author/tidy_author_data/data_author_naive_bayes.rds')
source('functions/f_get_fields.R')

# filter unknown names / names that could not have been classified by NB
# filter for NAs not necessary here since NA only appears if author name is
# not known
data_unknown <- data %>%
  filter(label == 'U') %>%
  select(gname) %>%
  unique()

# filter for names that are reasonable, i.e. have at least one vocal
data_unknown <- data_unknown %>%
  filter(str_detect(gname, '[aeiouy]')) %>%
  filter(!str_detect(gname, '[0-9]'))

names <- data_unknown$gname

# get data from gender-api
if (sure) {
  ## get authentication key
  source('authentication/gender_api_authentication.R')
  
  #initialization
  names_labels <- c()
  response_list <- list()
  
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
saveRDS(response_list, 'data/name/raw_name_data/names_api_raw.rds')
saveRDS(names_labels, 'data/name/tidy_name_data/names_api.rds')
}

names_labels <- readRDS('data/name/tidy_name_data/names_api.rds')

# adjust accuracy
names_labels$accuracy <- names_labels$accuracy / 100

# labeling
names_labels$gender <- ifelse(names_labels$accuracy <= .6 &
                                names_labels$accuracy >= .5,
                              'd_unisex',
                              names_labels$gender)

# extract shortcut
names_labels$gender <- names_labels$gender %>%
  str_sub(1, 1) %>%
  str_to_upper()

# introducing deccision threshold in variable names

# rename label column
names(data)[names(data) == 'label'] <- 'label_naive_bayes_6'
names(data)[names(data) == 'label_full_name'] <- 'label_full_name_6'
names(data)[names(data) == 'label_ending'] <- 'label_ending_6'

# add labels from gender-api
data <- left_join(data,
                  names_labels %>% select(gname = name_sanitized,
                                          label_api_6 = gender,
                                          p_api = accuracy))

# names that still could not have been classified
data$label_api <- ifelse(is.na(data$label_api_6),
                         'U',
                         data$label_api_6)

data$accuracy <- ifelse(is.na(data$p),
                        ifelse(is.na(data$p_ending),
                               data$p_api,
                               data$p_ending),
                        data$p)

data <- data %>%
  mutate(label_6 = ifelse(as.character(data$label_naive_bayes_6) == 'U',
                          data$label_api_6,
                          as.character(data$label_naive_bayes_6)) %>%
           factor())

# add different decision thresholds: 0.7, 0.75
data$label_7 <- ifelse(
  is.na(data$label_6),
  NA,
  ifelse(
    data$label_6 == 'U',
    'U',
    ifelse(
      data$accuracy <= .7,
      'D',
      as.character(data$label_6)))) %>%
  factor()

data$label_75 <- ifelse(
  is.na(data$label_6),
  NA,
  ifelse(
    data$label_6 == 'U',
    'U',
    ifelse(
      data$accuracy <= .75,
      'D',
      as.character(data$label_6)))) %>%
  factor()

# 
# # overview
# data$label_6 %>% table()
# data$label_7 %>% table()
# data$label_75 %>% table()

# save final labeled data
saveRDS(data, 'data/_final/data_author_labeled.rds')

