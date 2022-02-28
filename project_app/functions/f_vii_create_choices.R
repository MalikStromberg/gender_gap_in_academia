# this functions creates the available choices for table pages input

vii_create_choices <- function(npages, nitems, selected) {
  # if there are less pages than items to display
  if (npages <= nitems) {
    choices <- 1:npages
    dis <- NULL
  } else { # if not ...
    # extract choices that would originally be displayed
    min <- selected - round(nitems / 2, 0) + 3
    max <- selected + round(nitems / 2, 0) - 3
    choices <- min:max
    dis <- '0'
    # if we are at the lower bound
    if (any(choices == 3)) {
      choices <- 1:(nitems - 2)
      names(choices) <- as.character(choices)
      end <- npages
      names(end) <- as.character(end)
      choices <- list(choices,
                        '...' = 0,
                        end) %>% flatten()
      # if we are at the upper bound
    } else if (any(choices == npages - 2)) {
      choices <- seq.int(to = npages, length.out = nitems - 2)
      names(choices) <- as.character(choices)
      choices <- list('1' = 1,
                        '...' = 0,
                        choices) %>% flatten()
    } else { # if we are in the middle
      end <- npages
      names(end) <- as.character(end)
      choices <- list('1' = 1,
                        '...' = 0,
                        choices,
                        '...' = 0,
                        end) %>% flatten()
    }
  }
  ret <- list('choices' = choices, 'disabled' = dis)
}