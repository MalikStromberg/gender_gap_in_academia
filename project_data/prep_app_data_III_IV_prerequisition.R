# Sketch 'all_df' for Section IV and III

rm(list=ls())

library(dplyr)
library(tidyr)

source('functions/f_get_fields.R')
source('functions/f_create_numerics.R')
source('functions/f_smart_round.R')

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

# reduce data set to information of interest
data <- data %>% select(c(first_author,
                          any_of(get_fields(T)),
                          year,
                          label_6,
                          label_7,
                          label_75))
data <- data %>% filter(year <= 2020)
data <- data %>% filter(year >= 1960)

# get dummy coded columns
dummies <- get_fields(T)

# create dictionary to convert research fields into human readable names
dict <- data.frame(ui_field = get_fields(F) %>%
                     str_replace_all('and', '&') %>%
                     str_replace_all('Human Resource', 'HR') %>%
                     str_replace_all('miscellaneous', 'misc.') %>%
                     append('All Fields'),
                   field = get_fields(T) %>% append('all_fields'))

# add all_fields indicator to indicate articles only accure in the field
# gender studies
data$all_fields <- ifelse(
  (data$gender_studies) == 1 &
    (data %>%
       select(any_of(dummies)) %>%
       sapply(create_numerics) %>%
       rowSums() == 1),
  0,
  1
)

# just interested in economic and business fields, remove rows regarding
# gender studies
data <- data %>% filter(all_fields == 1)

# reduce data frame: remove dummy variables
data <- data %>% select(c('first_author',
                          'year',
                          'label_6',
                          'label_7',
                          'label_75'))



for (i in thresholds) {
  data_loop <- data %>% select(c('first_author', 'year', paste0('label_', i)))
  
  data_all <- data_loop %>%
    group_by(year, !!as.symbol(paste0('label_', i))) %>%
    summarize(nr_publications = n()) %>%
    ungroup()
  data_all$first_authors <- 0
  
  # just first authors
  data_first_authors <- data_loop %>%
    filter(first_author == 1) %>%
    group_by(year, !!as.symbol(paste0('label_', i))) %>%
    summarize(nr_publications = n()) %>%
    ungroup()
  data_first_authors$first_authors <- 1
  
  # combine both data frame
  data_loop <- data_all %>% bind_rows(data_first_authors)
  
  # add column ui_field and field 
  data_loop$field <- 'all_fields'
  data_loop$ui_field <- 'All Fields'
  label <- paste0('label_', i)
  names(data_loop)[names(data_loop) == label] <- 'gender'

  # spread as preparation for smart_round  
  data_loop <- data_loop %>% spread(key = gender, value = nr_publications)
  
  # add empty columns to fill with smart round results
  data_loop <- data_loop %>% cbind(
    "rounded.m" = NA,
    "rounded.f" = NA,
    "rounded.u" = NA,
    "rounded.d" = NA
  )
  
  for (j in 1:nrow(data_loop)) {
    
    x <-
      c(data_loop$M[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]),
        data_loop$F[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]),
        data_loop$U[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]),
        data_loop$D[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]))
    
    data_loop$rounded.m[j] <- smart_round(x * 100)[1]
    data_loop$rounded.f[j] <- smart_round(x * 100)[2]
    data_loop$rounded.u[j] <- smart_round(x * 100)[3]
    data_loop$rounded.d[j] <- smart_round(x * 100)[4]
    
    # data_loop$rounded.m[j] <- smart_round((data_loop$M[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]))*100)
    # data_loop$rounded.f[j] <- smart_round((data_loop$F[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]))*100)
    # data_loop$rounded.u[j] <- smart_round((data_loop$U[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]))*100)
    # data_loop$rounded.d[j] <- smart_round((data_loop$D[j]/sum(data_loop$M[j],data_loop$F[j],data_loop$D[j], data_loop$U[j]))*100)
  }
   
  data_prep <- data_loop %>% gather(M, F, U, D,
                                    key = 'gender',
                                    value = 'nr_publications')
  data_prep <- data_prep$nr_publications
    
  data_loop <-
    data_loop %>% gather(rounded.m,
                         rounded.f,
                         rounded.u,
                         rounded.d,
                         key = "gender",
                         value = "percentage_round")
  
  data_loop$gender <- data_loop$gender %>% gsub(pattern = "rounded.",
                                                replacement = "")
  
  # remove unwanted cols regarding gender nr. publications
  data_loop <- subset(data_loop, select = -c(D, F, M, U)) 
  
  # add information nr. publications
  data_loop$nr_publications <- data_prep
  
  # adapt values in gender column
  data_loop$gender <- tolower(data_loop$gender)
  
  # adapt type to factor variable 
  data_loop$first_authors <- as.factor(data_loop$first_authors)
  
  assign(paste0('data_', i), data_loop)
  
  # save data 
  saveRDS(data_loop, file = paste0("data/app/V_all_", i, ".rds"))
  
}

