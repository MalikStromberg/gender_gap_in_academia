viii_method <- function(font_color, font_family) {
  ret <- p(h3('Method', style = paste0('color:',
                                       font_color)),
           "The main challenge of our project was to automatically retrieve
           academic publishers' demographic data.
           Therefore, we decided to classify the authors' gender based on
           their surnames. For this we used a Naive Bayes classification
           algorithm, that assigned the classes female, male or unisex
           to the authors' name. If the algorithm could not come to a final
           decision, the name's ending has been considered. Again, if this
           was not successful, the name was sent to a gender classification ",
           a('API',
             href = 'https://gender-api.com/'),
           " to retrieve the respective classification. The algorithm has
           been put to a sanity check by comparing the result to the outcome
           of human coders' decisions.",
           style = paste0('color:',
                          font_color,
                          '; font-family:"',
                          font_family,
                          '"; ',
                          'align:"left";')
  )
  
  return(ret)
}