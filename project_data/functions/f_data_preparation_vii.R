# this function summarizes the data for section VII

data_preparation_vii <- function(data, dummies, dict, threshold,
                                 out.path = 'data/app/') {
  
  if (!require("tidyverse")) install.packages("tidyverse")
  if (!require("reshape2")) install.packages("reshape2")
  
  library(tidyverse)
  
  source('functions/f_create_numerics.R')
  
  label_col <- paste0('label_', threshold)
  
  # select relevant cols
  data <- data %>% select(any_of(dummies),
                          label = any_of(label_col),
                          'year',
                          'container.title',
                          'sjr',
                          'h_index')
  
  # add all_fields indicator to separate duplicates later without gender
  # studies
  data$all_fields <- ifelse(
    (data$gender_studies) == 1 &
      (data %>%
         select(any_of(dummies)) %>%
         sapply(create_numerics) %>%
         rowSums() == 1),
    0,
    1
  )
  
  # melt data for research field
  data <- reshape2::melt(data, id.vars = c('label',
                                           'year',
                                           'container.title',
                                           'sjr',
                                           'h_index')) %>%
    filter(value == '1')
  
  # summarize data
  data <- data %>%
    group_by(label, year, container.title, variable, sjr, h_index) %>%
    summarize(number = n()) %>%
    ungroup()
  
  # split data
  data_m <- data %>% filter(label == 'M') %>% select(-label, number.m = number)
  data_f <- data %>% filter(label == 'F') %>% select(-label, number.f = number)
  data_u <- data %>% filter(label == 'U') %>% select(-label, number.u = number)
  data_d <- data %>% filter(label == 'D') %>% select(-label, number.d = number)
  
  # join data and introduce per gender variables
  data <- left_join(
    data_m,
    data_f,
    by = c('year', 'variable', 'container.title', 'sjr', 'h_index')) %>%
    left_join(
      data_u,
      by = c('year', 'variable', 'container.title', 'sjr', 'h_index')) %>%
    left_join(
      data_d,
      by = c('year', 'variable', 'container.title', 'sjr', 'h_index'))
  
  # handle NAs
  data[is.na(data)] <- 0
  data$sjr[data$sjr == 0] <- NA
  
  # add relative values
  data <- bind_cols(
    data,
    lapply(data %>% select(starts_with('number')),
           FUN = function(x) {
             x / (data$number.m + data$number.f + data$number.u +
                    data$number.d)}) %>%
      as.data.frame(col.names = c('perc.m',
                                  'perc.f',
                                  'perc.u',
                                  'perc.d')))
  
  # f-m-ratio
  data$f_m_ratio <- data$number.f / data$number.m
  
  # adjust colnames
  colnames(data)[which(colnames(data) == 'variable')] <- 'field'
  
  data <- left_join(data, dict)
  
  # create dictionary that gives information about the research fields each
  # journal is assigned to
  dict_journals_field <- data %>% select(container.title, field, ui_field)
  data <- data %>% select(-c(field, ui_field)) %>% unique()
  
  # add journal ID
  container.title <- data$container.title %>% unique()
  container.id <- 1:length(container.title)
  
  container <- data.frame(container.title = container.title,
                          container.id = container.id)
  
  data <- data %>% left_join(container)
  dict_journals_field <- dict_journals_field %>% left_join(container)
  
  # The data for different fields is retrieved at different points in time.
  # Thus, there may be some differences in data for some journals that appear
  # in more than one research field. This issue is accounted for here
  data <- data %>%
    mutate(sum = number.m + number.f + number.u + number.d) %>%
    #group by all of them to secure nothing is deleted
    group_by(year, container.title, container.id, sjr, h_index) %>% 
    slice(which.max(sum)) %>%
    select(-sum) %>%
    ungroup()
  
  # save data
  saveRDS(dict_journals_field,
          paste0(out.path, 'VI_dict_', threshold, '.rds'))
  saveRDS(data,
          paste0(out.path, 'VI_', threshold, '.rds'))
}