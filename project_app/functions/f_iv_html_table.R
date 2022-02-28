# Fct html table for section IV
# install.packages("formattable")
library(formattable)

html_table_section4 <- function(data, field_input, dict, year_input, first_author_input, 
                                content_bg_color, font_color) {
  
  # Title 
  title <- dictionary_ext[dictionary_ext %in% field_input] %>% names()
  
  data_html_text_section4 <- data %>% filter(field == field_input,
                                             year == year_input,
                                             first_authors == first_author_input)
  
  # Checking avaiable data
  
  if (nrow(data_html_text_section4) == 0) {
    
    # Creating variable for warning message
    first_avaiable_data <- data %>% filter(field == field_input, first_authors == first_author_input)
    first_avaiable_data <- min(first_avaiable_data$year)
    
    html_text_section4 <- HTML(paste0(
      "<div style='background-color:", content_bg_color, "; font-size:12px; color:", font_color, "'>",
      "<table border='0' cellpadding='0' cellspacing='0'
      style='width: 80%;
      table-layout: fixed;
      text-align: center'>",
      
      "<TR style='border-bottom:1px solid #fcf5eb'>",
      "<caption width='100%' class = 'text-center'>", title, "</caption>",
      "</TR>",
      
      "<TR><TD  height='0'><p style='font-size:0px'",">&ensp;</p></TD></TR>",
      
      "<TR>",
      paste0("<TD align='center' class='text-center'>", 
             "No Data avaiable for this year.", 
             "</TD>"),
      "</TR>",
      
      "<TR>",
      paste0("<TD align='center' class='text-center'>",
             "Data provided from ", first_avaiable_data, ".",
             "</TD>"),
      "</TR>",
      
      "<TR> <TD> <br/> </TD> </TR>",
      "<TR> <TD> <br/> </TD> </TR>",
      "<TR> <TD> <br/> </TD> </TR>",

      
      "<TR><TD  height='0'><p style='font-size:0px'>&ensp;</p></TD></TR>",  # Some spacing at the bottom 
      "</table>",
      '</div>'))
  }
  
  else {
    nr_publications <- sum(data_html_text_section4$nr_publications)
  data_html_text_section4 <- data_html_text_section4$percentage_round
 
  
  html_text_section4 <- HTML(paste0(
  "<div style='background-color:", content_bg_color, "; font-size:12px; color:", font_color, "'>",
  "<table border='0' cellpadding='0' cellspacing='0' 
  style='width: 80%;
  table-layout: fixed;
  text-align: center'>",
 
  "<TR style='border-bottom:1px solid #fcf5eb'>",
  "<caption width='100%' class = 'text-center'>", title, "</caption>",
  "</TR>",
  
  "<TR><TD  height='0'><p style='font-size:0px'",">&ensp;</p></TD></TR>",
  
  "<TR>",
  paste0("<TD align='center' class='text-center'>", 
         data_html_text_section4[1], 
         "%</TD>"),
  paste0("<TD align='left'>", "Male", "</TD>"),
  "</TR>",
  
  "<TR>",
  paste0("<TD align='center' class='text-center'> ", 
         data_html_text_section4[2], 
         "%</TD>"),
  paste0("<TD align='left'>", "Female", "</TD>"),
  "</TR>",
  
  "<TR>",
  paste0("<TD align='center' class='text-center'>", 
         data_html_text_section4[3], 
         "%</TD>"),
  paste0("<TD align='left'>", "Unknown", "</TD>"),
  "</TR>",

  "<TR>",
  paste0("<TD align='center' class='text-center'>", 
         data_html_text_section4[4], 
         "%</TD>"),
  paste0("<TD align='left'>", "Unisex Names", "</TD>"),
  "</TR>",
  
  "<TR>",
  paste0("<TD align='center' class='text-center'>", 
         comma(nr_publications, format = "d"), 
         "</TD>"),
  paste0("<TD align='left'>", "Authors", "</TD>"),
  "</TR>",
  
  "<TR><TD  height='0'><p style='font-size:0px'>&ensp;</p></TD></TR>",
  "</table>",
  '</div>'))
  }
  
  
  
  return(html_text_section4)
}