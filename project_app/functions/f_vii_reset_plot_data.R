# this function resets the plot data if the user chooses to clear the plot

vii_reset_plot_data <- function(data, dict) {
  # extract journals of interest and relevant cols
  container <- dict %>%
    filter(field == 'all_fields') %>%
    .$container.id
  
  # add baseline trace
  data <- data %>%
    filter(container.id %in% container) %>%
    select(year, number.m, number.f) %>%
    group_by(year) %>%
    summarise_all(sum)
  # add relevant variables
  data$f_m_ratio <- data$number.f / data$number.m
  data$label <- 'All'
  data$table_choices <- 'All'
  data$index <- 'H-Index'
  
  return(data)
}