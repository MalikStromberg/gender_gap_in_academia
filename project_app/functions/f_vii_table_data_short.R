# this function creates the data (and only the data) that is shown in the table

vii_table_data_short <- function(data, inp_year, inp_graph, page, nrows, query) {
  # filter the data for selected input parameters
  data <- data %>% filter(year == inp_year, table_choices == inp_graph)
  
  if (nrow(data) > 0) {
    
    # specify index column
    if (all(data$index == 'SJR')) {
      idx <- 'sjr'
    } else {
      idx <- 'h_index'
    }
    
    # sort data by specified index
    data <- data[order(data[, idx], decreasing = T), ]
    
    # calculate overall selected field data
    overall <- data %>%
      select(number.m, number.f, number.u, number.d) %>%
      summarize_all(sum) %>%
      mutate(
        perc.m = paste0(
          round(
            number.m / (number.m + number.f + number.u + number.d) * 100,
            2),
          '%'),
        perc.f = paste0(
          round(
            number.f / (number.m + number.f + number.u + number.d) * 100,
            2),
          '%'),
        f_m_ratio = as.character(round(number.f / number.m, 2))) %>%
      select(-starts_with('number'))
    
    overall$container.title <- 'Overall'
    
    # add rank
    data$rank <- 1:nrow(data)
    
    # filter for search term
    data <- data %>% filter(
      str_detect(str_to_lower(container.title),
                 str_to_lower(query)))
    
    # extract number of data points for page choice buttons
    nobs <- nrow(data)
    
    if (nobs > 0) {
      # extract the rows that should be displayed in the table
      data <- data[(((page - 1) * nrows) + 1):(page * nrows), ]
      
      # make values human readable and select displayed cols
      data <- data %>%
        mutate(perc.m = paste0(round(perc.m * 100, 2), '%'),
               perc.f = paste0(round(perc.f * 100, 2), '%'),
               f_m_ratio = as.character(round(f_m_ratio, 2))) %>%
        select(rank,
               group,
               container.title,
               one_of(idx),
               perc.m,
               perc.f,
               f_m_ratio) %>%
        mutate_if(is.numeric, ~ formatC(.x, big.mark = ','))
    } else {
      data <- data.frame(
        'rank' = NA,
        'group' = NA,
        'container.title' = 'No Journals Found.',
        'index' = NA,
        'perc.m' = NA,
        'perc.f' = NA,
        'f_m_ratio' = NA
      )
    }

  } else {
    data <- data.frame(
      'rank' = NA,
      'group' = NA,
      'container.title' = 'No Journals Found.',
      'index' = NA,
      'perc.m' = NA,
      'perc.f' = NA,
      'f_m_ratio' = NA
    )
    idx <- 'index'
    nobs <- 1
    overall <- data.frame(
      'rank' = NA,
      'group' = NA,
      'container.title' = 'Overall',
      'index' = NA,
      'perc.m' = NA,
      'perc.f' = NA,
      'f_m_ratio' = NA
    )
  }
  
  # add overall data
  data <- bind_rows(data, overall)
  
  # combine all relevant data
  data_ret <- list(data = data, index = idx, nobs = nobs)
  
  return(data_ret)
}