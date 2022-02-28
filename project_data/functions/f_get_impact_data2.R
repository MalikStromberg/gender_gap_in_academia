# this function retrieves impact data from scimagojr.com

get_impact_data2 <- function(years, sleep = 5) {
  if (!require("tidyverse")) install.packages("tidyverse")
  library(tidyverse)
  
  # initialization
  data_all <- c()
  
  # retrieve all selected years
  for (i in years) {
    url <- paste('https://www.scimagojr.com/journalrank.php?year=',
                 i,
                 '&out=xls',
                 sep = '')
    data <- suppressMessages(suppressWarnings(
      read_delim(url(url), delim = ';', escape_double = T)))
    
    # adjust names
    names <- colnames(data)
    names <- names %>%
      str_to_lower() %>%
      str_replace_all(pattern = paste(' [(]', i, '[)]$', sep = ''),
                      replacement = '') %>%
      str_replace_all(pattern = ' ',
                      replacement = '_') %>%
      str_replace_all(pattern = '[.]',
                      replacement = '')
    colnames(data) <- names
    
    # add year column
    data$year <- i
    
    # bind data
    data_all <- bind_rows(data_all, data)
    
    # give server time to breath
    Sys.sleep(sleep)
  }
  
  return(data_all)
}