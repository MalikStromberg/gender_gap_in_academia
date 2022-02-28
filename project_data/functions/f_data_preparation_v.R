# this function summarizes the data for section V and saves it

data_preparation_v <- function(data,
                               dummies, # dummy coded columns
                               dict,
                               threshold,
                               out.path = 'data/app/') {
  
  if (!require("tidyverse")) install.packages("tidyverse")
  if (!require("reshape2")) install.packages("reshape2")
  
  library(tidyverse)
  
  label_col <- paste0('label_', threshold)
  
  # create copy for later
  data_copy <- data
  
  
  ############################################################################
  ### All Authors ###
  ###################
  
  
  # filter data for relevant years
  data <- data %>% select(any_of(dummies),
                          label = any_of(label_col),
                          year) %>%
    filter(year >= 1960 & year <= 2020)
  
  # melt data
  data <- reshape2::melt(data, id.vars = c('label',
                                           'year')) %>%
    filter(value == '1') %>%
    # summarize data by year and research field
    group_by(label, year, variable) %>%
    summarize(number = n()) %>%
    ungroup()
  
  # # summarize data by year and research field
  # data <- data %>%
  #   group_by(label, year, variable) %>%
  #   summarize(number = n()) %>%
  #   ungroup()
  
  # split data
  data_m <- data %>% filter(label == 'M') %>% select(-label, number.m = number)
  data_f <- data %>% filter(label == 'F') %>% select(-label, number.f = number)
  data_u <- data %>% filter(label == 'U') %>% select(-label, number.u = number)
  data_d <- data %>% filter(label == 'D') %>% select(-label, number.d = number)
  
  # join together and introduce variables per gender
  data <- left_join(data_m,
                    data_f,
                    by = c('year', 'variable')) %>%
    left_join(data_u,
              by = c('year', 'variable')) %>%
    left_join(data_d,
              by = c('year', 'variable'))
  
  data[is.na(data)] <- 0
  
  # calculate relative values
  data <- bind_cols(
    data,
    lapply(
      data %>%
        select(starts_with('number')),
      FUN = function(x) {
        x / (data$number.m + data$number.f +
               data$number.u + data$number.d)}) %>%
      as.data.frame(
        col.names = c('perc.m',
                      'perc.f',
                      'perc.u',
                      'perc.d')))
  
  # f-m-ratio
  data$f_m_ratio <- data$number.f / data$number.m
  
  # adjust variable names
  colnames(data)[which(colnames(data) == 'variable')] <- 'field'
  
  data_a <- data
  
  ############################################################################
  ## First Authors ##
  ###################
  
  # same for first authors
  
  data <- data_copy
  
  data <- data %>% filter(first_author == 1) %>%
    select(any_of(dummies),
           label = any_of(label_col),
           'year') %>%
    filter(year >= 1960 & year <= 2020)
  
  data <- reshape2::melt(data, id.vars = c('label',
                                           'year')) %>%
    filter(value == '1') %>%
    group_by(label, year, variable) %>%
    summarize(number = n()) %>%
    ungroup()
  
  # data <- data %>%
  #   group_by(label, year, variable) %>%
  #   summarize(number = n()) %>%
  #   ungroup()
  
  data_m <- data %>% filter(label == 'M') %>% select(-label, number.m = number)
  data_f <- data %>% filter(label == 'F') %>% select(-label, number.f = number)
  data_u <- data %>% filter(label == 'U') %>% select(-label, number.u = number)
  data_d <- data %>% filter(label == 'D') %>% select(-label, number.d = number)
  
  data <- left_join(data_m,
                    data_f,
                    by = c('year', 'variable')) %>%
    left_join(data_u,
              by = c('year', 'variable')) %>%
    left_join(data_d,
              by = c('year', 'variable'))
  
  data[is.na(data)] <- 0
  
  data <- bind_cols(
    data,
    lapply(data %>% select(starts_with('number')),
           FUN = function(x) {
             x / (data$number.m + data$number.f + data$number.u + 
                    data$number.d)}) %>%
      as.data.frame(
        col.names = c('perc.m',
                      'perc.f',
                      'perc.u',
                      'perc.d')))
  
  
  data$f_m_ratio <- data$number.f / data$number.m
  
  colnames(data)[which(colnames(data) == 'variable')] <- 'field'
  
  data_b <- data
  
  ############################################################################
  ## Combined ##
  ##############
  
  # combine both data sets and introduce indicator variable
  
  data_a$first_authors <- 0
  data_b$first_authors <- 1
  
  # combine data set
  data <- bind_rows(data_a, data_b)
  data$first_authors <- data$first_authors %>% as.factor()
  
  data <- left_join(data, dict)
  
  # save data for section V
  saveRDS(data, paste0(out.path, 'V_', threshold, '.rds'))
}