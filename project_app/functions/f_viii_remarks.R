viii_remarks <- function(font_color, font_family) {
  ret <- p(h3('Remarks', style = paste0('color:',
                                        font_color)),
           "The female to male ratio represents the number of researchers
           classified as female divided by the number of researchers
           classified as male and thus, can be considered as the odds
           in disregard of the researchers with a name classified as
           unisex.",
           br(),
           "The research field of Gender Studies has been added as an
           additional field for comparison. When selecting 'All Fields',
           Gender Studies is not captured, since it is not categorized
           as a field of Business and Economics.",
           br(),
           "If you have any feedback, questions or further remarks, do
           not hesitate to contact us.",
           style = paste0('color:',
                          font_color,
                          '; font-family:"',
                          font_family,
                          '"; ',
                          'align:"left";')
  )
  
  return(ret)
}