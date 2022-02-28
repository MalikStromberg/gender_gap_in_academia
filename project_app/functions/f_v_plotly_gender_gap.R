# this function creates the graphs for section V depending on the selected
# research fields

v_plotly_gender_gap <- function(data, fields, click,
                            year.min = 1960, year.max = 2020,
                            legend = T, font_family, font_size,
                            bg_color, font_color, graph_colors) {
  # make sure that there is only one year selected
  # important because sometimes a click between years makes them both appear
  # in the click input
  click <- click[1]
  
  # make sure the selected year is displayed on the x-axis
  years <- seq(year.min, year.max, 10)
  if (!is.null(click)) {
    years <- years[which(abs(years - click) > 3)]
    years <- append(years, click)
  }
  
  # create subplot titles
  title <- ifelse(data$first_authors[1] == 0,
                  'All Authors',
                  'Only First Authors')
  text <- list(text = title,
               font = list(size = font_size + 5,
                           family = font_family,
                           color = font_color),
                xref = "paper",
                yref = "paper",
                yanchor = "bottom",
                xanchor = "center",
                align = "center",
                x = 0.5,
                y = 1,
                showarrow = FALSE
              )
  

  # create plot data based on selected fields
  plot_data <- data %>%
    filter(field %in% fields &
             year %in% c(year.min:year.max))
  
  # create plotly object
  plot <- plot_data %>%
    plot_ly(source = 'V')
  
  # if any field selected
  if (!is.null(plot_data)) {
    # add data
    plot <- plot %>%
      add_paths(x = ~year,
                y = ~f_m_ratio,
                color = ~ui_field,
                colors = graph_colors[1:length(fields)],
                legendgroup = ~ui_field,
                text = ~ui_field,
                hoverinfo = 'text',
                type = 'scatter',
                mode = 'lines',
                showlegend = legend)
  } else {
    plot_data <- matrix(0, 1, ncol(data))
    colnames(plot_data) <- colnames(data)
  }

  
  # add line at selected year
  if (!is.null(click)) {
    plot <- plot %>%
      add_segments(x = click,
                   xend = click,
                   y = 0,
                   yend = max(plot_data %>%
                                filter(year == click[1]) %>%
                                select(f_m_ratio)),
                   showlegend = F, color = I(font_color),
                   text = click,
                   hoverinfo = 'text')
  }
  
  # specify plot layout
  plot <- plot %>%
    layout(
      # hovern
      hovermode = 'x',
      hoverlabel = list(
        font = list(family = font_family,
                    size = font_size)),
      # x-axis
      xaxis = list(
        color = font_color,
        title = list(text = 'year',
                     standoff = 4,
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = F,
        tickvals = years,
        tickangle = 0,
        range = c(1958, 2022),
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family)),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'female / male ratio',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family)),
        margin = list(l = 80, r = 80, t = 30, b = 30),
        paper_bgcolor = bg_color,
        plot_bgcolor = bg_color,
        annotations = text
      ) %>%
    config(displayModeBar = FALSE) # do not show plotly mode bar
  
  
  return(plot)
}