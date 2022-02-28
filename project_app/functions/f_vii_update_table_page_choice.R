# this function calculates the number of pages of the table at current
# input parameters and adjusts the selected page if the user induces page
# is out of bounds

vii_update_table_page_choice <- function(table_nobs,
                                         selected_page,
                                         n_items,
                                         nrows) {
  if (n_items < 10) {
    n_items <- 10
  }
  
  # check if there are any observations
  if (table_nobs != 0) {
    
    # check if selected page is still smaller than upper limit
    selected <- ifelse(selected_page > (table_nobs %/% nrows) + 1,
                       (table_nobs %/% nrows) + 1,
                       selected_page)
    
    # adjust number of available pages
    if (table_nobs %% nrows == 0) {
      
      npages <- table_nobs %/% nrows
      
    } else {
      
      npages <- (table_nobs %/% nrows) + 1
      
    }
    
    # create choices for this case
    choices <- vii_create_choices(npages = npages,
                                  nitems = n_items,
                                  selected = as.numeric(selected))
  } else {
    
    # if no data points automatically select page 1
    selected <- 1
    choices <- list('choices' = 1, 'disabled' = NULL)
  }
  
  # make sure that the selected page is within the bounds
  if (!(as.numeric(selected) %in% as.numeric(choices$choices))) {
    
    selected <- max(choices$choices)
    
  }
  
  # combine data for updating the buttons
  data_ret <- list(selected = selected,
                   choices = choices)
}