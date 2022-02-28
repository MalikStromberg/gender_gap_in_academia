# this function returns all collected fields from crossref

if (!require("stringr")) install.packages("stringr")
library(stringr)

get_fields <- function(converted = F) {
  fields <- c('General Business, Management and Accounting',
              'Business, Management and Accounting (miscellaneous)',
              'Accounting',
              'Business and International Management',
              'Management Information Systems',
              'Management of Technology and Innovation',
              'Marketing',
              'Organizational Behavior and Human Resource Management',
              'Strategy and Management',
              'Tourism, Leisure and Hospitality Management',
              'General Decision Sciences',
              'Decision Sciences (miscellaneous)',
              'Information Systems and Management',
              'Management Science and Operations Research',
              'Statistics, Probability and Uncertainty',
              'General Economics, Econometrics and Finance',
              'Economics, Econometrics and Finance (miscellaneous)',
              'Economics and Econometrics',
              'Finance',
              'Gender Studies')
  
  if (converted) {
    fields <- str_remove_all(fields, '[&,]') %>%
      str_replace_all(' ', '_') %>%
      str_to_lower()
  }
  
  return(fields)
}