# this function resets the table data, if the user chooses to clear the plot

vii_reset_table_data <- function(data, dict) {
  # extract journals of interest and relevant cols
  container <- dict %>%
    filter(field == 'all_fields') %>%
    .$container.id
  
  # add data of baseline trace
  data <- data %>%
    filter(container.id %in% container) %>%
    select(year,
           container.id,
           number.m,
           number.f,
           number.u,
           number.d,
           f_m_ratio,
           sjr,
           h_index,
           container.title,
           perc.m,
           perc.f)
  # add relevant variables
  data$label <- 'All'
  data$table_choices <- 'All'
  data$index <- 'H-Index'
  data$group <- NA
  
  return(data)
}