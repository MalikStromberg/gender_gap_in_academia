# Creating legend with dummy variable

# Creating new function with dummy plot since the function plot_geom_waffle has 
# no legend which can be extracted.

iv_get_legend <- function(data, 
                          content_bg_color, graph_colors, font_color) {

  # Create dummy data frame
  df_dummy <- data %>% filter(year == 2020, field == 'accounting', first_authors == 0)
  
  plot_dummy <- ggplot(data = df_dummy,
                       aes(
                         fill = gender,
                         values = percentage_round,
                         colour = gender
                       )) +
    geom_waffle(n_rows = 10,
                colour = content_bg_color,
                flip = FALSE) +
    scale_fill_manual(
      values = graph_colors,
      labels = c("Male", "Female", "Unknown Author", "Unisex Name"),
      name = NULL
    ) +
    theme(legend.direction = "horizontal",
          legend.background = element_rect(fill = content_bg_color),
          legend.key = element_rect(colour = content_bg_color),
          legend.text = element_text(family = "serif", size = 13, color = font_color),
          legend.title = element_text(family = "serif", size = 13, color = font_color),
          plot.margin = unit(c(0,0,0,0), "cm")
          ) +  
    coord_equal()
  
  # Create legend
  legend <- cowplot::get_legend(plot = plot_dummy)
  
  # Remove dummy plot and dummy df
  remove(plot_dummy, df_dummy)
  return(legend)
}




