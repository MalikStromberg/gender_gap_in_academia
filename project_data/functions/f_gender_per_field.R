gender_per_field <- function(data, names, endings, unknowns,
                                     threshold) {
  source('functions/f_get_fields.R')
  library(tidyverse)
  
  # preparing author data
  data$name_ending <- substr(data$gname,
                             nchar(data$gname) - 2,
                             nchar(data$gname))
  
  # only years are of interest here
  data$pub.print.year <- substr(data$published.print, 1, 4) %>%
    as.numeric()
  data$pub.online.year <- substr(data$published.online, 1, 4) %>%
    as.numeric()
  
  data <- data %>% select(-c(published.online, published.print))
  
  data$year <- ifelse(
    ifelse(is.na(data$pub.online.year),
           9999,
           data$pub.online.year) <
      ifelse(is.na(data$pub.print.year),
             9999,
             data$pub.print.year),
    data$pub.online.year,
    data$pub.print.year
  )
  
  data <-data %>% select(-c(pub.online.year, pub.print.year))
  data <- data %>% filter(year >= 1960 & year <= 2020)
  
  # preparing full name data
  names$label <- NA
  names$label <- ifelse(names$p_male_name > .5, 'M', 'F')
  names$label <- ifelse(
    (names$p_male_name >= 1 - threshold) & (names$p_male_name <= threshold),
    'D',
    names$label)
  
  names$p <- apply(cbind(names$p_male_name, names$p_female_name),
                       1,
                       max)
  names <- names %>% select(gname = name, label, p)
  
  # preparing names ending data
  endings$label <- NA
  endings$label <- ifelse(endings$p_male_name > .5, 'M', 'F')
  endings$label <- ifelse(
    (endings$p_male_name >= 1 - threshold) &
      (endings$p_male_name <= threshold),
    'D',
    endings$label)
  
  endings$p <- apply(
    cbind(endings$p_male_name, endings$p_female_name), 1, max)
  
  endings <- endings %>% select(name_ending,
                                label_ending = label,
                                p_ending = p)
  
  # joining name data
  data <- left_join(data, names, by = 'gname')
  data$label <- data$label %>% replace_na('U')
  
  data <- left_join(data, endings, by = 'name_ending')
  data$label_ending <- data$label_ending %>% replace_na('U')
  
  # classification (1st step: Naive Bayes)
  data$gender <- ifelse(data$label == 'U',
                        data$label_ending,
                        data$label)
  
  data$gender <- ifelse(is.na(data$gname) |
                          nchar(data$gname) == 0,
                        NA,
                        data$gender)
  
  data$label <- ifelse(is.na(data$gname) |
                          nchar(data$gname) == 0,
                       NA,
                       data$label)
  
  labels <- factor(data$gender)
  
  labels_full_name <- factor(data$label)
  
  data$label <- labels
  data$label_full_name <- labels_full_name
  
  # preparing API-data
  unknowns$accuracy <- unknowns$accuracy / 100
  
  unknowns$gender <- ifelse(unknowns$accuracy <= threshold &
                                  unknowns$accuracy >= .5,
                                'd_unisex',
                                unknowns$gender)
  
  unknowns$gender <- unknowns$gender %>%
    str_sub(1, 1) %>%
    str_to_upper()
  
  # joining API data (2nd step)
  names(data)[names(data) == 'label'] <- 'label_naive_bayes'
  
  data <- left_join(data,
                    unknowns %>% select(gname = name_sanitized,
                                            label_api = gender,
                                            accuracy_api = accuracy))
  
  data$label_api <- ifelse(is.na(data$label_api),
                           'U',
                           data$label_api)
  
  data$label <- ifelse(as.character(data$label_naive_bayes) == 'U',
                       data$label_api,
                       as.character(data$label_naive_bayes)) %>% factor()
  
  # aggregating data
  data <- data %>% select(any_of(get_fields(T)),
                          'label')
  data <- reshape2::melt(data, id.vars = c('label')) %>%
    filter(value == '1')
  
  data <- data %>%
    group_by(label, variable) %>%
    summarize(number = n()) %>%
    ungroup()
  
  data_m <- data %>% filter(label == 'M') %>% select(-label, number.m = number)
  data_f <- data %>% filter(label == 'F') %>% select(-label, number.f = number)
  data_u <- data %>% filter(label == 'U') %>% select(-label, number.u = number)
  data_d <- data %>% filter(label == 'D') %>% select(-label, number.d = number)
  
  data <- left_join(data_m,
                    data_f,
                    by = c('variable')) %>%
    left_join(data_u,
              by = c('variable')) %>%
    left_join(data_d,
              by = c('variable'))
  
  data[is.na(data)] <- 0
  
  data <- bind_cols(data,
                    lapply(data %>% select(starts_with('number')),
                           FUN = function(x) {
                             x / (data$number.m + data$number.f +
                                    data$number.u + data$number.d)}) %>%
                      as.data.frame(col.names = c('perc.m',
                                                  'perc.f',
                                                  'perc.u',
                                                  'perc.d')))
  
  
  data$f_m_ratio <- data$number.f / data$number.m
  
  colnames(data)[which(colnames(data) == 'variable')] <- 'field'
  
  return(data)
}