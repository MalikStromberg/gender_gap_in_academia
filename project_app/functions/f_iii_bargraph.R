# Plot function for section III (Bargraph)

iii_barplot <- function(data, field_input, first_authors_input, 
                        content_bg_color, active_input_color, inactive_input_color, graph_colors, 
                        font_color, font_family) {
  
  # Plot Data
  plot_df <- data  %>% 
  filter(field == field_input, first_authors == first_authors_input)

  # Create Plotly Object
  
plot <- plot_df  %>%
  plot_ly(
    x = ~ percentage,
    y = ~ gender,
    frame = ~ year,
    ids = ~ gender,
    hoverinfo = "text",  
    text =  ~paste(percentage, "%",gender,"\n", 
                   comma(nr_publications, format = "d"), "Authors"),
    marker = list(color = graph_colors)
  ) %>%
  add_bars() %>%
  layout(showlegend = FALSE,
         hovermode = 'x',
         hoverlabel = list(
           font = list(
             family = font_family,
             size = 12,
             color = content_bg_color)),
         xaxis = list(color = font_color,
                      title = list(text = "",
                                   font = list(
                                     family = font_family, 
                                     size = '14px', color = font_color)),
                      fixedrange = T,
                      ticksuffix = "%",
                      tickfont = list(size = '12px',
                                      color = font_color,
                                      family = font_family)),
         yaxis = list(color = font_color,
                      title = list(text = "",
                                   font = list(
                                     family = font_family, 
                                     size = '14px', color = font_color)),
                      fixedrange = T,
                      autorange = F,
                      tickfont = list(size = '12px',
                                      color = font_color,
                                      family = font_family)),
         paper_bgcolor = content_bg_color,
         plot_bgcolor = content_bg_color) %>% 
  
  animation_slider(currentvalue = list(
    prefix = NULL,
    font = list(
      color = font_color,
      family = font_family, 
      size = "20px"
    )
  ),
  font = list(color = font_color,
              family = font_family),
  bgcolor = inactive_input_color,   
  bordercolor = inactive_input_color,
  activebgcolor = inactive_input_color
  ) %>% 
  
  # Play button 
  animation_button(font = list(color = font_color,
                               family = font_family,
                               size = "20px"),
                   bgcolor = '#dec5ab',   
                   bordercolor = '#dec5ab') %>%
  config(displayModeBar = FALSE)

return(plot)
}


