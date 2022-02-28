# this data generates the data for a specific trace that is added by the user

vii_plot_data <- function(data, dict, new_trace, selected_field, index,
                          weights, weighting, existing_labels) {

  # extract journals of interest and relevant cols
  container <- dict %>%
    filter(field == selected_field) %>%
    .$container.id
  data_plot <- data %>%
    filter(container.id %in% container) %>%
    select(year,
           any_of(index),
           perc.m,
           perc.f,
           number.m,
           number.f,
           number.u,
           number.d,
           container.id,
           f_m_ratio,
           container.title)
  # extract user readable field name
  field_ui <- dict %>%
    filter(field == selected_field) %>%
    select(ui_field) %>%
    unique()
  field_ui$ui_field <- field_ui$ui_field
  
  # create label for trace
  label <- paste0('<b>',
                  field_ui$ui_field %>%
                    strwrap(18, simplify = F) %>%
                    sapply(paste, collapse = "<br>"),
                  '</b>:<br>',
                  min(new_trace),
                  ' Qu. (',
                  weights[1],
                  ')<br>',
                  max(new_trace),
                  ' Qu. (',
                  weights[2],
                  ')<br>100 Qu. (',
                  weights[3],
                  ')<br>',
                  ifelse(weighting == 'quantile',
                         'not impact-weighted',
                         'impact-weighted'),
                  '<br>[',
                  ifelse(index == 'sjr',
                         'SJR',
                         'H-Index'),
                  ']')
  # create trace label for picker input for table data
  choices <- paste0(field_ui$ui_field,
                    ' [',
                    ifelse(index == 'sjr',
                           'SJR',
                           'H-Index'),
                    ']: ',
                    min(new_trace),
                    ' Qu. (',
                    weights[1],
                    '), ',
                    max(new_trace),
                    ' Qu. (',
                    weights[2],
                    '), 100 Qu. (',
                    weights[3],
                    '); ',
                    ifelse(weighting == 'quantile',
                           'not impact-weighted',
                           'impact-weighted'))
  # check if trace with same parameters is already present in the plot
  if (!(label %in% existing_labels)) {
    # filter for NAs in selected index and calculate selected quantiles
    
    data_plot <- data_plot %>%
      filter(!is.na(!!as.symbol(index)))
    
    # calculate lower quantile per year / best journals
    quant_min <- data_plot %>%
      select(year, !!as.symbol(index)) %>%
      group_by(year) %>%
      summarize_all(quantile, probs = 1 - (min(new_trace) / 100)) %>%
      ungroup()
    colnames(quant_min) <- c('year', 'quant.min')
    
    # calculate upper quantile per year / worst journals
    quant_max <- data_plot %>%
      select(year, !!as.symbol(index)) %>%
      group_by(year) %>%
      summarize_all(quantile, probs = 1 - (max(new_trace) / 100)) %>%
      ungroup()
    colnames(quant_max) <- c('year', 'quant.max')
    
    # join quantiles by year
    data_plot <- data_plot %>%
      left_join(quant_min, by = 'year') %>%
      left_join(quant_max, by = 'year')
    
    # add group variable
    data_plot$group <- ifelse(
      data_plot[, index] >= data_plot$quant.min,
      'upper',
      ifelse(
        data_plot[, index] >= data_plot$quant.max,
        'medium',
        'lower')) %>%
      factor()
    
    # add class weight for each journal
    data_plot$weight_class <- ifelse(
      data_plot[, index] >= data_plot$quant.min,
      weights[1],
      ifelse(
        data_plot[, index] >= data_plot$quant.max,
        weights[2],
        weights[3])) %>%
      factor()
    
    # select relevant columns
    data_table <- data_plot %>%
      filter(weight_class != 0) %>%
      select(year,
             group,
             container.id,
             perc.m,
             perc.f,
             number.m,
             number.f,
             number.u,
             number.d,
             f_m_ratio,
             any_of(index),
             container.title)
    
   # transform weight class 
    data_plot$weight_class <- create_numerics(data_plot$weight_class)
    
    if (weighting == 'quantile') {
      # calculate weighted number of genders without index weighting
      data_plot <- data_plot %>%
        mutate(number.f.weighted = number.f * weight_class,
               number.m.weighted = number.m * weight_class)
    } else {
      # calculate weighted number of genders with index weighting
      data_plot <- data_plot %>%
        mutate(
          number.f.weighted = number.f * weight_class * !!as.symbol(index),
          number.m.weighted = number.m * weight_class * !!as.symbol(index)
        )
    }
    
     # summarize per year
     data_plot <- data_plot %>%
      select(year,
             number.m,
             number.f,
             number.m.weighted,
             number.f.weighted) %>%
       group_by(year) %>%
       summarize_all(sum) %>%
       ungroup()
     # f-m-ratio
     data_plot$f_m_ratio <- data_plot$number.f.weighted /
       data_plot$number.m.weighted
    
     # add human readable research field and specified parameters
    data_plot$field <- field_ui$ui_field
    data_plot$quant1 <- min(new_trace)
    data_plot$quant2 <- max(new_trace)
    data_plot$weight1 <- weights[1]
    data_plot$weight2 <- weights[2]
    data_plot$weight3 <- weights[3]
    data_plot$index <- ifelse(index == 'sjr',
                             'SJR',
                             'H-Index')
    
    data_plot$label <- label
    data_plot$table_choices <- choices
    data_table$table_choices <- choices
    data_table$index <- ifelse(index == 'sjr',
                              'SJR',
                              'H-Index')

    # combine table and plot data
    data_ret <- list(plot = data_plot,
                     table = data_table)
    
    return(data_ret)
  } else {
    return(data.frame(plot = c(), table = c()))
  }
  
}