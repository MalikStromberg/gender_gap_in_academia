get_crossref_data <- function (field,
                               cursor_max = 20000,
                               path = 'data/author/raw_author_data/') {
  
  if (!require("rcrossref")) install.packages("rcrossref")
  if (!require("tidyverse")) install.packages("tidyverse")
  library(rcrossref)
  library(tidyverse)
  
  # get number of search results
  n_results <- cr_works(filter = c(category_name = field),
                        limit = 0)$meta$total_results
  
  # initialization
  n_data <- 0
  idx <- 0
  limit <- 1000
  crit <- cursor_max
  max_data <- crit
  
  while (crit >= max_data) {
      # generate appropriate data name
      dat_name <- str_remove_all(field, '[&,]') %>%
        str_replace_all(' ', '_') %>%
        str_to_lower() %>%
        paste(idx, sep = '_')
      # set cursor for first access
      if (idx == 0) {
        cursor <- '*'
      }
      
      if (n_results - n_data < cursor_max) {
        cursor_max <- max(249, n_results - n_data)
        limit <- 250
      }
      
      # request and receive data
      tryCatch({assign(dat_name,
                       cr_works(filter = c(category_name = field),
                                cursor = cursor,
                                cursor_max = cursor_max,
                                # number of requested results;
                                # caution: unstable server
                                limit = limit # maximum limit = 1000
             ))},
             error = function(e){})
      
      # calculate maximum number of data points in this iteration
      max_data <- ifelse(cursor_max %% limit == 0,
                         (cursor_max %/% limit) * limit,
                         ((cursor_max %/% limit) + 1) * limit)
      
      if (is.null(get(dat_name)$meta$next_cursor) &
          get(dat_name)$data %>% nrow() %% limit == 0) {
        # reduce number of requested data points if request failed
        cursor_max <- max(5000, cursor_max / 2)
        # alternative:
        #cursor_max <- max(5000, get(dat_name)$data %>% nrow())
        
        # set equal to induce next iteration
        crit <- max_data
      } else {
        cursor <- get(dat_name)$meta$next_cursor
        # if all requested data was successfully received set index +1
        idx <- idx + 1
        n_data <- n_data + get(dat_name)$data %>% nrow()
        crit <- get(dat_name)$data %>% nrow()
      }
      
      # save received data
      saveRDS(get(dat_name),
              paste(path, dat_name, '.rds', sep = ''))
      
      # progress control
      print(paste('Got', n_data, 'of', n_results, 'data points.', sep = ' '))
      
      # give the server 5 seconds to breath
      Sys.sleep(5)
  }
}