# Function for creating a waffle chart with geom_waffle

plot_geom_waffle_chart <- function(data, fields, year_input, first_author_input,
                                   content_bg_color, graph_colors
) {  
  
  # Prepare Data
  waffle_chart <- data %>%
    filter(fields == field,
           year == year_input,
           first_authors == first_author_input)
  
  # Create plot object
  plot <- ggplot(data = waffle_chart, 
                 aes(fill = gender, 
                     values = percentage_round,
                     colour = gender)) +
    waffle::geom_waffle(n_rows = 10, 
                size = 1.75, 
                colour = content_bg_color, 
                flip = FALSE) +
    
    scale_fill_manual(values = graph_colors,
                      labels = c("Male", "Female", "Unknown Author", "Unisex name"),
                      name = "Gender") +
    coord_equal() +
    theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      legend.position = "none",
      text = element_text(size = 18, family = "TNR"),
      plot.background = element_rect(fill = content_bg_color, colour = content_bg_color),
      panel.background = element_rect(fill = content_bg_color),
      legend.background = element_rect(fill = content_bg_color),
      strip.background = element_rect(fill = content_bg_color),
      plot.margin = unit(c(-0.1, -0.1, -0.1,-0.1), "cm")
    )
  
  return(plot)
}