# this script stacks the data, such that there is a single data set for each
# field

rm(list = ls())

source('functions/f_stack_author_data.R')
source('functions/f_get_fields.R')

# choose all retrieved research fields
fields <- get_fields()

for (i in fields) {
  stack_author_data(i)
}
