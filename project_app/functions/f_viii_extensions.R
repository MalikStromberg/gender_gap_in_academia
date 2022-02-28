viii_extensions <- function(font_color, font_family) {
  ret <- p(h3('Extensions', style = paste0('color:',
                                           font_color)),
           "The data considered in this project can effortlessly be extended to
           other Sciences and research fields when investing time to retrieve
           the data. The limit of possible app features has not been reached by
           far, yet.",
           style = paste0('color:',
                          font_color,
                          '; font-family:"',
                          font_family,
                          '"; ',
                          'align:"left";')
  )
  
  return(ret)
}