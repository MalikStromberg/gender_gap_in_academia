# this script creates reduced data sets optimized for section V and VII of the
# app

rm(list=ls())

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("reshape2")) install.packages("reshape2")

library(tidyverse)

source('functions/f_get_fields.R')
source('functions/f_data_preparation_v.R')
source('functions/f_data_preparation_vii.R')
source('functions/f_create_numerics.R')

###############################################################################
## All Authors ##
#################

# read data
data <- readRDS('data/_final/data_author_labeled.rds')

# extract thresholds
thresholds <- data %>%
  colnames() %>%
  data.frame() %>%
  filter(str_detect(., 'label_[0-9]+')) %>%
  .$. %>%
  str_remove_all('label_') %>%
  as.numeric()

# replace NAs by unknown label
data <- data %>%
  mutate_at(
    vars(paste0('label_', thresholds)),
    ~ replace_na(., 'U'))

# get dummy coded columns
dummies <- get_fields(T)

# create dictionary to convert research fields into human readable names
dict <- data.frame(ui_field = get_fields(F) %>%
                     str_replace_all('and', '&') %>%
                     str_replace_all('Human Resource', 'HR') %>%
                     str_replace_all('miscellaneous', 'misc.') %>%
                     append('All Fields'),
                   field = get_fields(T) %>% append('all_fields'))

# data preparation for section V

for (i in thresholds) {
  data_preparation_v(data = data,
                     dummies = dummies,
                     dict = dict,
                     threshold = i,
                     out.path = 'data/app/')
}


###############################################################################
###############################################################################
## Journal Level Data ##
########################

# read data
data <- readRDS('data/_final/data_author_labeled_impact.rds')

# extract thresholds again for new data set
thresholds <- data %>%
  colnames() %>%
  data.frame() %>%
  filter(str_detect(., 'label_[0-9]+')) %>%
  .$. %>%
  str_remove_all('label_') %>%
  as.numeric()

# replace NAs by unknown label
data <- data %>%
  mutate_at(
    vars(paste0('label_', thresholds)),
    ~ replace_na(., 'U'))

# adopt container name from impact data
data$container.title <- ifelse(is.na(data$title.imp),
                               data$container.title,
                               data$title.imp)

# assure that same container has same container name
container_unique <- data %>%
  select(issn.imp, container.title) %>%
  unique()

# remove HTML codes
container_unique$container.title <- container_unique$container.title %>%
  str_replace_all('<html_ent glyph="@amp;" ascii="&amp;"/>', '&') %>%
  str_replace_all('&amp;', '&') %>%
  str_replace_all('&apos;', "'") %>%
  str_replace_all('<html_ent glyph="@eacute;" ascii="e"/>', 'E')
container_unique <- container_unique %>% filter(!duplicated(issn.imp))

data <- data %>% select(-container.title) %>% left_join(container_unique)

for (i in thresholds) {
  data_preparation_vii(data = data,
                       dummies = dummies,
                       dict = dict,
                       threshold = i,
                       out.path = 'data/app/')
}
