# this function creates a the tables for section V depending on the selected
# input fields and chosen year

v_table <- function(data, fields, click, dict, font_size, bg_color,
                    font_color) {
  # make sure that there is only one year selected
  # important because sometimes a click between years makes them both appear
  # in the click input
  click <- click[1]
  if (is.null(fields) | any(is.na(fields))) {
    
    # initialize table values
    mat <- matrix('&ensp;', nrow = 4, ncol = ncol(data)) %>%
      data.frame()
    
    # transform into characters
    dat <- setNames(mat, names(data)) %>%
      mutate_all(as.character)
    
  } else if (!is.null(click)) {
    
    # filter data for relevant years
    dat <- data %>%
      filter(year == click & field %in% fields) %>%
      mutate(f_m_ratio = round(f_m_ratio, 2))
    
    # make ratio user friendly
    # add big mark
    dat <- dat %>% mutate_if(is.numeric, ~ formatC(.x, big.mark = ','))
    
    # initialize table values
    mat <- matrix('&ensp;', nrow = (4 - nrow(dat)), ncol = ncol(dat)) %>%
      data.frame()
    
    # transform into characters
    dat <- rbind(dat, setNames(mat, names(dat))) %>%
      mutate_all(as.character)
    
    # show selected research fields if no years is selected
  } else {
    
    # initialize table data
    dat <- matrix('&ensp;', nrow = 4, ncol = ncol(data)) %>% data.frame()
    colnames(dat) <- names(data)
    
    # show selected fields though
    dat$ui_field[1:length(fields)] <- dict[dict %in% fields] %>% names()
  }
  

  # create HTML table
  text <- HTML(paste0(
    "<div style='background-color:",
    bg_color,
    "; font-size:",
    font_size,
    "px; color:",
    font_color,
    "'>",
    "<table border='0' cellpadding='0' cellspacing='0' style='margin:25px'>",
    "<TR><TD COLSPAN='4' height='0'><p style='font-size:0px'>&ensp;</p></TD></TR>",
    "<TR style='border-bottom:1px solid ", font_color, "'>",
    "<TH width='440' align='left'>Field</TH>",
    "<TH width='145' class='text-center'>Female Authors</TH>",
    "<TH width='145' class='text-center'>Male Authors</TH>",
    "<TH width='125' class='text-center'>Ratio</TH>",
    "</TR>",
    "<TR>",
    paste0("<TD width='440' align='left'>", dat$ui_field[1], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.f[1], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.m[1], "</TD>"),
    paste0("<TD width='125' align='center'>", dat$f_m_ratio[1], "</TD>"),
    "</TR>",
    "<TR>",
    paste0("<TD width='440' align='left'>", dat$ui_field[2], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.f[2], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.m[2], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$f_m_ratio[2], "</TD>"),
    "</TR>",
    "<TR>",
    paste0("<TD width='440' align='left'>", dat$ui_field[3], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.f[3], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.m[3], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$f_m_ratio[3], "</TD>"),
    "</TR>",
    "<TR>",
    paste0("<TD width='440' align='left'>", dat$ui_field[4], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.f[4], "</TD>"),
    paste0("<TD width='145' align='center'>", dat$number.m[4], "</TD>"),
    paste0("<TD width='125' align='center'>", dat$f_m_ratio[4], "</TD>"),
    "</TR>",
    "<TR><TD COLSPAN='4' height='0'><p style='font-size:0px'>&ensp;</p></TD></TR>",
    "</table>",
    '</div>'
  )
  )
  return(text)
}