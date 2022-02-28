# this function produces a HTML table for section VII for the selected input
# parameters

# create_html_table has to be sourced globally

vii_table <- function(data, bg_color, font_color, font_size) {
  
  # data_table needs some time to develop when app is started
  if (!is.null(data$data)) {
    # style specifications
    alignment <- c('center', 'center', 'left', 'center',
                   'center', 'center', 'center')
    widths <- c(35, 60, 440, 75, 75, 75, 75)
    
    # information about whole selected trace data
    bottom_line <- create_html_table(data = data$data %>%
                                       filter(container.title == 'Overall'),
                                     align = alignment,
                                     width = widths) %>%
      str_replace_all(
        '<TR>',
        paste0("<TR style='border-top:1px solid",
               font_color,
               "; font-weight:bold'>"))
    
    # adjust index column title
    if (data$index == 'sjr') {
      idx <- 'SJR'
    } else {
      idx <- 'H-Index'
    }
    
    text <- paste0(
      "<div style='background-color:",
      bg_color,
      "; font-size:",
      font_size,
      "px; color:",
      font_color,
      "'>",
      "<table border='0' cellpadding='0' cellspacing='0'
    style='margin:25px; margin-top:0px;'>",
      "<TR><TD COLSPAN='7' height='0'><p style='font-size:0px'>
    &ensp;</p></TD></TR>",
      "<TR style='border-bottom:1px solid ", font_color, "'>",
      "<TH width='35' class='text-center'>Rank</TH>",
      "<TH width='60' class='text-center'>Group</TH>",
      "<TH width='440' align='left'>Journal</TH>",
      "<TH width='75' class='text-center'>", idx, "</TH>",
      "<TH width='75' class='text-center'>Male</TH>",
      "<TH width='75' class='text-center'>Female</TH>",
      "<TH width='75' class='text-center'>female/male</TH>",
      "</TR>",
      create_html_table(data = data$data %>%
                          filter(container.title != 'Overall'),
                        align = alignment,
                        width = widths),
      bottom_line,
      "<TD COLSPAN='7' height='0'><p style='font-size:0px'>
      &ensp;
      </p></TD></TR>",
      "</table>",
      '</div>'
    ) %>%
      str_replace_all('>NA<', '>&ensp;<') # no NAs in the table
  } else {
    text <- 'Initializing ...'
  }

  
  text <- HTML(text)
  return(text)
}