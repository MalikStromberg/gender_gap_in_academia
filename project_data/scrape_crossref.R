
rm(list = ls())

# CAUTION: running the whole script at once would make R busy for many hours!
#          That is also why we don't use a for-loop for iterating through the
#          fields

# Checklist:
# 1. save mail in .Renviron: crossref_email = <your email>
# 2. restart R session
# 3. set working directory
# 4. make sure that there exists a folder named "raw_author_data" or set
#    different path argument in get_crossref_data
# 5. type in correct research field
# 6. select reasonable number of data points per request to start with  
#    in get_crossref_data (if you want); default: 20000
# 7. remember date of request for documentation

# set your email here with crossref_email = <your email>
file.edit('~/.Renviron')
# save and restart R-Session

# the subject areas can be found at
# https://service.elsevier.com/app/answers/detail/a_id/15181/supporthub/scopus/related/1/
# it is an elsevier url because they use the same structure

source('functions/f_get_crossref_data.R')

#### Field 1400

# request date: 20.11.2020
field <- 'General Business, Management and Accounting'
get_crossref_data(field)


#### Field 1401

# request date: 21.11.2020
field <- 'Business, Management and Accounting (miscellaneous)'
get_crossref_data(field)


#### Field 1402

# request date: 22.11.2020
field <- 'Accounting'
get_crossref_data(field)


#### Field 1403

# request date: 22.11.2020
field <- 'Business and International Management'
get_crossref_data(field)


### Field 1404

# request date: 24.11.2020
field <- 'Management Information Systems'
get_crossref_data(field)

### Field 1405

# request date: 24.11.2020
field <- 'Management of Technology and Innovation'
get_crossref_data(field)


#### Field 1406

# request date: 24.11.2020
field <- 'Marketing'
get_crossref_data(field)


#### Field 1407 

# request date: 30.11.2020
field <- 'Organizational Behavior and Human Resource Management'
get_crossref_data(field)


#### Field 1408

# request date: 27.11.2020
field <- 'Strategy and Management'
get_crossref_data(field, cursor_max = 50000)


#### Field 9
# request date: 27.11.2020
field <- 'Finance'
get_crossref_data(field, cursor_max = 50000)


#### Field 10
# request date: 27.11.2020
field <- 'Economics, Econometrics and Finance (miscellaneous)'
get_crossref_data(field, cursor_max = 50000)


#### Field 11
# request date: 27.11.2020
field <- 'Gender Studies'
get_crossref_data(field, cursor_max = 50000)


#### Field 1409 

# request date: 03.12.2020
field <- 'Tourism, Leisure and Hospitality Management'
get_crossref_data(field)


#### Field 1410 [missing]

# request date: 25.11.2020 und 27.11.2020
# Problem: Ended nach kurzer Zeit und gibt folgendes aus:
# "Got 0 of 0 data points."
field <- 'Industrial Relations'
get_crossref_data(field)


#### Field 1800 

# request date: 01.12.2020
field <- 'General Decision Sciences'
get_crossref_data(field)


##### Field 1801 

# request date: 01.12.2020
field <- 'Decision Sciences (miscellaneous)'
get_crossref_data(field)


#### Field 1802 [missing]

# request date: 02.12.2020
field <- 'Information Systems and Management'
get_crossref_data(field)


#### Field 1803 [missing]

# request date: 25.11.2020
field <- 'Management Science and Operations Research'
get_crossref_data(field)


#### Field 1804 [missing, war viel]

# request date: 27.11.2020
field <- 'Statistics, Probability and Uncertainty'
get_crossref_data(field)


#### Field 2000 [missing]

# request date: 27.11.2020
field <- 'General Economics, Econometrics and Finance'
get_crossref_data(field)


