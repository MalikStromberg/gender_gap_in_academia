# this function produces a plotly object with all user added traces for
# section VII

vii_plotly_impact <- function(data, click,
                              year.min = 1999, year.max = 2019,
                              legend = T, font_family, font_size,
                              paper_bg_color, font_color, bg_color,
                              graph_colors) {
  # factorize label
  data$label <- as.factor(data$label)
  
  # make sure that only one year is selected
  click <- click[1]
  
  # specify trace colors
  if (length(levels(data$label)) > 1) {
    
    levels <- levels(data$label)[which(levels(data$label) != 'All')]
    cols <- rep(graph_colors,
                (length(levels) %/% 4) + 1)[1:length(levels)] %>%
      append(font_color)
    names(cols) <- levels %>% append('All')
    
  } else {
    cols <- font_color
  }

  # create text for x ticks
  years <- seq(year.min, year.max, 5)
  if (!is.null(click)) {
    years <- years[which(abs(years - click) > 3)]
  }
  years <- append(years, click)
  
  # create plot object with input data
  plot <- data %>%
    plot_ly(source = 'VII') %>%
    add_paths(x = ~year,
              y = ~f_m_ratio,
              color = ~label,
              colors = cols[1:length(levels(data$label))],
              legendgroup = ~label, text = ~label,
              hoverinfo = 'text',
              type = 'scatter', mode = 'lines', showlegend = legend)
  
  # if year is selected add line
  if (!is.null(click)) {
    plot <- plot %>%
      add_segments(x = click, xend = click,
                   y = min(data$f_m_ratio) - .05,
                   yend = max(data %>% filter(year == click[1]) %>%
                                select(f_m_ratio)),
                   showlegend = F, color = I(font_color),
                   text = click,
                   hoverinfo = 'text')
  }
  
  # specify appearance
  plot <- plot %>%
    layout(
      # title
      title = list(
        text = 'Weighted Female to Male Ratio',
        font = list(
          family = font_family,
          size = font_size + 5,
          color = font_color
        )
      ),
      # legend
      legend = list(
        font = list(size = font_size - 3,
                    color = font_color)),
      # hovern
      hovermode = 'x',
      hoverlabel = list(
        font = list(
          family = font_family,
          size = font_size - 2,
          color = paper_bg_color)),
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
        range = c(1998, 2020),
        showgrid = T,
        visible = T,
        showline = T,
        tickfont = list(
          size = font_size,
          color = font_color,
          family= font_family)),
      # y-axis
      yaxis = list(
        color = font_color,
        title = list(text = 'female / male ratio',
                     font = list(
                       family = font_family,
                       size = font_size + 2,
                       color = font_color)),
        fixedrange = T,
        autorange = F,
        range = c(min(data$f_m_ratio) - .05,
                  max(data$f_m_ratio) + .05),
        showgrid = T,
        tickfont = list(size = font_size,
                        color = font_color,
                        family = font_family)),
      margin = list(l = 60, r = 150, t = 50, b = 30),
      paper_bgcolor = bg_color,
      plot_bgcolor = bg_color) %>%
    config(displayModeBar = FALSE) # no plotly mode bar
  
  return(plot)
}