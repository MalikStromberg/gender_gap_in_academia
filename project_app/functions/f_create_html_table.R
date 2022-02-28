# this function transforms a data frame into an HTML-table

create_html_table <- function(data, align, width) {
  # add table cell parameters
  for (i in 1:ncol(data)){
    data[, i] <- paste0(
      "<TD width='",
      width[i],
      "' align='",
      align[i],
      "'>",
      data[, i][[1]],
      "</TD>"
    )
  }
  
  # paste columns
  ret <- apply(data, 1, paste0, collapse = '')
  
  # paste rows
  ret <- paste0(paste0("<TR>", ret, "</TR>"), collapse = '')
  return(ret)
}