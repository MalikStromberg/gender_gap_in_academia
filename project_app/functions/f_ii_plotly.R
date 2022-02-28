# this function produces all plot objects for section II

ii_plotly <- function(data, selected_field, colors, font_family, font_size,
                      font_color, bg_color, error_color,
                      year.min = 1960,
                      year.max = 2020) {

  for (i in 1:(length(data))) {
    data[[i]] <- data[[i]] %>%
      filter(field == selected_field)
  }
  
  years <- seq(year.min, year.max, 10)
  
  ### plot for number of publications
  plot_publications <- data$publications %>%
    plot_ly() %>%
    add_paths(x = ~year,
              y = ~n_publications,
              line = list(color = colors[1]),
              text = ~n_publications,
              hoverinfo = 'y',
              type = 'scatter',
              mode = 'lines',
              showlegend = F) %>%
    layout(
      # title
      title = list(
        text = 'Number of Publications Over Time',
        font = list(
          family = font_family,
          size = font_size + 5,
          color = font_color
        )
      ),
      # hovern
      hovermode = 'x',
      hoverlabel = list(
        font = list(
          family = font_family,
          size = font_size,
          color = font_color)),
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
        range = c(1959, 2021),
        showgrid = T,
        visible = T,
        showline = T,
        tickfont = list(
          size = font_size,
          color = font_color,
          family = font_family)),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'Number of Publications',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = T,
        showgrid = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family),
        zeroline = F),
      margin = list(l = 60, r = 60, t = 50, b = 30),
      paper_bgcolor = bg_color,
      plot_bgcolor = bg_color) %>%
    config(displayModeBar = FALSE) # no plotly mode bar

  ### plot for number of journals
  plot_journals <- data$journals %>%
    plot_ly() %>%
    add_paths(x = ~year,
              y = ~n_journals,
              line = list(color = colors[2]),
              text = ~n_journals,
              hoverinfo = 'text',
              type = 'scatter',
              mode = 'lines',
              showlegend = F) %>%
    layout(
      # title
      title = list(
        text = 'Number of Journals Over Time',
        font = list(
          family = font_family,
          size = font_size + 5,
          color = font_color
        )
      ),
      # hovern
      hovermode = 'x',
      hoverlabel = list(
        font = list(
          family = font_family,
          size = font_size,
          color = font_color)),
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
        range = c(1959, 2021),
        showgrid = T,
        visible = T,
        showline = T,
        tickfont = list(
          size = font_size,
          color = font_color,
          family = font_family)),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'Number of Journals',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = T,
        showgrid = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family),
        zeroline = F),
      margin = list(l = 60, r = 60, t = 50, b = 30),
      paper_bgcolor = bg_color,
      plot_bgcolor = bg_color) %>%
    config(displayModeBar = FALSE) # no plotly mode bar
  
  ### plot for average number of authors per publication
  plot_avg_authors <- data$avg_authors %>%
    plot_ly() %>%
    # errors
    add_ribbons(x = ~year,
                ymin = ~avg_authors  - deviation,
                ymax = ~avg_authors + deviation,
                line = list(color = error_color),
                fillcolor = error_color,
                hoverinfo = 'none') %>%
    # line
    add_paths(x = ~year,
              y = ~avg_authors,
              line = list(color = colors[3]),
              text = ~round(avg_authors, 2),
              hoverinfo = 'text',
              type = 'scatter',
              mode = 'lines',
              showlegend = F) %>%
    layout(
      # title
      title = list(
        text = 
          'Average Number of Authors per Publication and Standard Deviation',
        font = list(
          family = font_family,
          size = font_size + 5,
          color = font_color
        )
      ),
      # hovern
      hovermode = 'x',
      hoverlabel = list(
        font = list(
          family = font_family,
          size = font_size,
          color = error_color)),
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
        range = c(1959, 2021),
        showgrid = T,
        visible = T,
        showline = T,
        tickfont = list(
          size = font_size,
          color = font_color,
          family = font_family)),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'Average Number of Authors',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = T,
        showgrid = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family),
        zeroline = F),
      margin = list(l = 60, r = 60, t = 50, b = 30),
      paper_bgcolor = bg_color,
      plot_bgcolor = bg_color) %>%
    config(displayModeBar = FALSE) # no plotly mode bar
  
  ### density for h_index
  density <- data$impact$h_index %>% density(na.rm = T)
  density <- data.frame(h_index = density$x,
                        density = density$y)
  
  plot_impact <- density %>%
    plot_ly() %>%
    add_paths(x = ~h_index,
              y = ~density,
              line = list(color = colors[4]),
              hoverinfo = 'none',
              type = 'scatter',
              mode = 'lines',
              showlegend = F) %>%
    layout(
      # title
      title = list(
        text = 'Density of the H-Index',
        font = list(
          family = font_family,
          color = font_color,
          size = font_size + 5
        )
      ),
      # no hover
      hovermode = 'x',
      hoverlabel = list(
        font = list(
          family = font_family,
          size = font_size,
          color = font_color)),
      # x-axis
      xaxis = list(
        color = font_color,
        title = list(text = 'H-Index',
                     standoff = 4,
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = T,
        tickangle = 0,
        showgrid = T,
        visible = T,
        showline = T,
        tickfont = list(
          size = paste0(font_size - 2, 'px'),
          color = font_color,
          family = font_family),
        zeroline = F,
        rangemode = 'nonnegative'),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'Density',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = T,
        showgrid = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family),
        zeroline = F),
      margin = list(l = 60, r = 60, t = 50, b = 30),
      paper_bgcolor = bg_color,
      plot_bgcolor = bg_color) %>%
    config(displayModeBar = FALSE) # no plotly mode bar
  
  # list plots and return
  data_ret <- list(plot_publications = plot_publications,
                   plot_journals = plot_journals,
                   plot_avg_authors = plot_avg_authors,
                   plot_impact = plot_impact)
  
  return(data_ret)
  
}