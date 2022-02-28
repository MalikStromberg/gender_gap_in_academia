# this function creates one data set for a specific research field retrieved
# from Crossref out of all scraped data sets

stack_author_data <- function(field,
                             in.path = 'data/author/raw_author_data/',
                             out.path = 'data/author/stacked_author_data/') {
  
  if (!require("tidyverse")) install.packages("tidyverse")
  library(tidyverse)
  
  # adjust data name
  dat_name <- str_remove_all(field, '[&,]') %>%
    str_replace_all(' ', '_') %>%
    str_to_lower()
  
  # initialization
  data_collect <- data.frame('alternative.id' = c())
  
  # create data set names
  pat <- '^' %>% paste(paste(dat_name, '[0-9]+', sep = '_'), sep = '')
  pat <- pat %>% str_replace_all('[(]', '[(]')
  pat <- pat %>% str_replace_all('[)]', '[)]')
  
  # find data sets
  n <- in.path %>%
    list.files(pattern = pat, full.names = TRUE, recursive = TRUE) %>%
    length()
  
  # read data sets and bind them
  for (idx in 0:(n - 1)) {
      data_temp <- in.path %>%
        paste(dat_name, sep = '') %>%
        paste(idx, sep = '_') %>%
        paste('rds', sep = '.') %>%
        readRDS()
    
      data_collect <- bind_rows(data_collect, data_temp$data)
  }
  
  # add field identifier
  dummy <- data.frame(rep(1, nrow(data_collect)))
  colnames(dummy) <- dat_name
  data_collect <- bind_cols(data_collect, dummy)
  
  # save complete data set for the specific research field
  data_collect %>% saveRDS(out.path %>% paste(dat_name, '.rds', sep = ''))
}