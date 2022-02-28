viii_project_goal <- function(font_color, font_family) {
  ret <- p(h3('Story and Project Goal', style = paste0('color:',
                                                       font_color)),
           "During spring 2020 discussions about gender gaps in different
           areas reached the public interest due to the Covid-19 pandemic.
           Suddenly, traditional role models popped up again and women tend
           to step back from their jobs to care for their children rather
           than men (",
           a('nature.com',
             href = 'https://www.nature.com/articles/d41586-020-01294-9',
             .noWS = c('outside')),
           ", ",
           a('bbc.com',
             href = 'https://www.bbc.com/news/business-55002687',
             .noWS = c('outside')),
           "). After just a few months there was evidence
           that women published less in academia and we started to ask
           ourselves: What is the distribution of gender in academic
           publications regardless of Covid-19? How did it change over the
           last years and in different research fields?",
           br(),
           "We decided not to develop a pure academic analysis of the topic,
           but rather to provide a tool that enables all users to visualize,
           discover, and analyze interesting aspects of the gender gap in
           academic publications in Business and Economics. The goal of this
           project is to give users the opportunity to acquire substantial
           knowledge about the development and distribution of this gender
           disparities. It can be compared across time and research fields.
           Moreover, different journals and their impact factor can be
           considered.",
    style = paste0('color:',
                   font_color,
                   '; font-family:"',
                   font_family,
                   '"; ',
                   'align:"left";')
  )
  
  return(ret)
}