viii_data <- function(font_color, font_family) {
  ret <- p(h3('Data', style = paste0('color:',
                                     font_color)),
           "The data about academic publications is retrieved from ",
           a('Crossref',
             href = 'https://www.crossref.org/'),
           " through their provided ",
           a('API',
             href = 'https://www.crossref.org/education/retrieve-metadata/rest-api/'),
           ". For the Naive Bayes algorithm data from
           US social security card applicants is used. The remained names
           which could not be labeled by the algorithm are classified by
           calling ",
           a('gender-api.com.',
             href = 'https://gender-api.com/'),
           " To extend the journal information by impact
           indices, data from ",
           a('scimagojr.com',
             href = 'https://www.scimagojr.com/'),
           " is retrieved.",
           style = paste0('color:',
                          font_color,
                          '; font-family:"',
                          font_family,
                          '"; ',
                          'align:"left";')
  )
  
  return(ret)
}