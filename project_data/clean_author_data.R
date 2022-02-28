# this script tidies the author data from crossref, i.e. imposes a
# meaningful structure
# this script deals with huge data sets that will only reduce until the end
# of the script
# you may want to clear your RAM at the highlighted points in script

# due to memory restrictions the combination of the research field specific
# data sets is split into two parts producing data_10 for the first 10
# research fields, followed by data_20 for the subsequent 10

rm(list = ls())

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("plyr")) install.packages("plyr") # ubuntu needs this seperately
if (!require("doParallel")) install.packages("doParallel")

library(tidyverse)
library(doParallel) 

source('functions/f_get_fields.R')

fields <- get_fields(T)

# read first 10 data sets
for (i in 1:10) {
  dat_name <- 'data' %>% paste(i, sep = '')
  assign(dat_name,
         'data/author/stacked_author_data/' %>%
           paste(fields[i], '.rds', sep = '') %>%
           readRDS())
}

# bind the data sets
data_10 <- bind_rows(mget(paste('data', c(1:10), sep = '')))

# remove from workspace
rm(list = c(paste('data', c(1:10), sep = '')))

# dummy encoding of research fields
data_temp <- data_10 %>% select(fields[1:10])
data_temp[is.na(data_temp)] <- 0

# select relevant cols
data_10 <- data_10 %>% select(container.title,
                              published.print,
                              published.online,
                              doi,
                              issn,
                              issue,
                              page,
                              publisher,
                              is.referenced.by.count,
                              subject,
                              title,
                              type,
                              volume,
                              language,
                              author,
                              reference,
                              funder)

# add dummy encoding for research fields
data_10 <- bind_cols(data_10, data_temp)

# remove from workspace
rm(data_temp)

# save data from first 10 research fields
saveRDS(data_10, 'data/author/stacked_author_data/data_10.rds')

# remove from workspace
rm(data_10)

###############################################################################

# same procedure for next 10 research fields
for (i in 11:20) {
  dat_name <- 'data' %>% paste(i, sep = '')
  assign(dat_name,
         'data/author/stacked_author_data/' %>%
           paste(fields[i], '.rds', sep = '') %>%
           readRDS())
}

data_20 <- bind_rows(mget(paste('data', c(11:20), sep = '')))

rm(list = c(paste('data', c(11:20), sep = '')))

data_temp <- data_20 %>% select(fields[11:20])
data_temp[is.na(data_temp)] <- 0

data_20 <- data_20 %>% select(container.title,
                              published.print,
                              published.online,
                              doi,
                              issn,
                              issue,
                              page,
                              publisher,
                              is.referenced.by.count,
                              subject,
                              title,
                              type,
                              volume,
                              language,
                              author,
                              reference,
                              funder)

data_20 <- bind_cols(data_20, data_temp)

rm(data_temp)

saveRDS(data_20, 'data/author/stacked_author_data/data_20.rds')

rm(data_20)

###############################################################################
####### You may want to restart your R-Session at this point ##################
###############################################################################

# load packages again after restart
library(tidyverse)

source('functions/f_get_fields.R')

fields <- get_fields(T)

# read data sets
data_10 <- readRDS('data/author/stacked_author_data/data_10.rds')
data_20 <- readRDS('data/author/stacked_author_data/data_20.rds')

# bind to one huge data set
data <- bind_rows(data_10, data_20)

# remove single data sets
rm(list = c('data_10', 'data_20'))

# remove large and probably irrelevant columns, otherwise computationally too
# expensive
data <- data %>% select(-c(funder, reference))

data_temp <- data %>% select(any_of(fields))
data <- data %>% select(-any_of(fields))

data_temp[is.na(data_temp)] <- 0

# convert to factors
factor_columns <- c('publisher', 'type', 'language')
data[, factor_columns] <- data[, factor_columns] %>%
  lapply(factor) %>%
  data.frame

data <- bind_cols(data, data_temp)
rm(data_temp)

# save
saveRDS(data, 'data/author/temp_author_data/data_author.rds')
rm(data)

###############################################################################
####### You may want to restart your R-Session at this point ##################
###############################################################################

# load packages again after restart
library(tidyverse)

source('functions/f_get_fields.R')

fields <- get_fields(T)

# read data set after restart
data <- readRDS('data/author/temp_author_data/data_author.rds')

# summarize publications that appear in more than one research field
dummies <- data %>%
  group_by(doi = doi) %>%
  summarize_at(fields, sum)

dummies_factors <- dummies %>% select(-doi)
dummies_factors[dummies_factors > 1] <- 1

dummies[, fields] <- dummies_factors
rm(dummies_factors)
dummies[, fields] <- dummies[, fields] %>%
  lapply(factor) %>%
  data.frame()

# save research field dummies
saveRDS(dummies, 'data/author/temp_author_data/dummies.rds')
rm(dummies)

data <- data %>% select(-all_of(fields))

# make each publication only appear once
data <- data %>% distinct()
doi_dubs <- data$doi[duplicated(data$doi)]
data_dubs <- data %>% filter(doi %in% doi_dubs)
data <- data %>% filter(!(doi %in% doi_dubs))

# if a publication appears twice...
# this could happen because research fields are scraped at different points in
# time
# take the most recent data
data_dubs <- data_dubs %>% plyr::ddply(
  "doi", function(x) x[which.max(x$is.referenced.by.count), ])

data <- bind_rows(data, data_dubs)

# bring dummies back into play
dummies <- readRDS('data/author/temp_author_data/dummies.rds')
dummies$doi %in% data$doi %>% table()
data <- left_join(data, dummies, by = 'doi')
rm(dummies)
rm(data_dubs)

# save data sets
saveRDS(data, 'data/author/temp_author_data/data_author_dummies.rds')
data <- select(data, doi, author)
saveRDS(data, 'data/author/temp_author_data/data_author.rds')
rm(data)
rm(doi_dubs)

###############################################################################
####### You may want to restart your R-Session at this point ##################
###############################################################################

# load packages again after restart
library(tidyverse)
library(doParallel) 

source('functions/f_get_fields.R')

fields <- get_fields(T)

# read data after restart
data <- readRDS('data/author/temp_author_data/data_author.rds')

# BE CAREFUL if your CPU is currently busy
cl <- makeCluster(parallel::detectCores()/2) # makeCluster(number of cores)
registerDoParallel(cl)

# create an observation for each author of each publication
start2 <- Sys.time()
data_author <-
  foreach(i = 1:nrow(data), .inorder = F) %dopar% {
    if (!is.null(data[i, 'author'][[1]]$given)) {
      dplyr::bind_cols(
        'doi' = rep(data[i, 'doi'], nrow(data[i, 'author'][[1]])),
        'author_gname' =  data[i, 'author'][[1]]$given,
        'n_author' = seq_along(data[i, 'author'][[1]]$given),
        'first_author' = ifelse(data[i, 'author'][[1]]$sequence == 'first',
                                1,
                                0))
    } else if (!is.null(data[i, 'author'][[1]]$family)) {
      dplyr::bind_cols(
        'doi' = rep(data[i, 'doi'], nrow(data[i, 'author'][[1]])),
        'author_gname' =  data[i, 'author'][[1]]$family,
        'n_author' = seq_along(data[i, 'author'][[1]]$family),
        'first_author' = ifelse(data[i, 'author'][[1]]$sequence == 'first',
                                1,
                                0))
    }
  }
end2 <- Sys.time()

time2 <- end2 - start2
time2
# 20mins wall time

stopCluster(cl)

# convert list into data frame
data_author <- data.frame(rlist::list.rbind(data_author))

# convert names
data_author$author_gname <- data_author$author_gname %>%
  iconv(from = 'UTF-8', to = 'ASCII//TRANSLIT') %>%
  str_replace_all('-', ' ') %>%
  str_remove_all('[[:punct:]]')

# make a column for each given name
n_fnames <- max(str_count(data_author$author_gname, ' '), na.rm = T)
into <- paste('name', 1:(n_fnames + 1), sep = '')

data_author <- separate(data_author, author_gname, into = into, sep = ' ')

# delete names that do not fulfill the conditions: more than 1 character,
# no dots
data_author[, into] <- data.frame(
  apply(data_author[, into],
        2,
        function (x) replace(x,
                             which(nchar(x) == 1 |
                                  str_detect(x, pattern = '^[a-zA-Z][.]')),
                             NA)))

# fill NAs with other given names of the author to get the most reasonable
# first name as the first name variable
for (i in 2:(n_fnames + 1)) {
  j <- paste('name', i, sep= '')
  data_author$name1 <- ifelse(is.na(data_author$name1),
                              data_author[,j],
                              data_author$name1)
}

# select columns
data_author <- data_author %>% 
  select(doi = doi,
         gname = name1, 
         n_author = n_author,
         first_author = first_author) %>%
  # add identifier for first authors
  mutate(first_author = as.factor(first_author),
         gname = str_to_title(gname))

# save reduced data set
saveRDS(data_author, 'data/author/temp_author_data/data_author_gnames.rds')
rm(data_author)

###############################################################################
####### You may want to restart your R-Session at this point ##################
###############################################################################

# load packages again after restart
library(tidyverse)

source('functions/f_get_fields.R')

fields <- get_fields(T)

# read data after restart
# left join names with data
data <- readRDS('data/author/temp_author_data/data_author_dummies.rds')
data_author <- readRDS('data/author/temp_author_data/data_author_gnames.rds')

# join data sets: research field dummies, author given names
data <- left_join(data_author, data, by = 'doi')

rm(data_author)

saveRDS(data, 'data/author/tidy_author_data/data_author.rds')

rm(data)
###############################################################################
####### You may want to restart your R-Session at this point ##################
###############################################################################

# load packages again after restart
library(tidyverse)

source('functions/f_get_fields.R')

fields <- get_fields(T)

# labeling

# read data after restart
data_name <- readRDS('data/name/tidy_name_data/names_db.rds')
data_name_ending <- readRDS('data/name/tidy_name_data/names_ending.Rds')
data_author <- readRDS('data/author/tidy_author_data/data_author.rds')

# select relevant cols
data_name_ending <- data_name_ending %>%
  select(name_ending,
         label_ending = label,
         p_ending = p)
data_name <- data_name %>% select(gname = name, label, p)

data_author <- data_author %>% select(gname)

# extract last 3 characters of authors given name
data_author$name_ending <- substr(data_author$gname,
                                  nchar(data_author$gname) - 2,
                                  nchar(data_author$gname))

# join name labeling
data_author <- left_join(data_author, data_name, by = 'gname')
data_author$label <- data_author$label %>% replace_na('U')

# join names ending labeling
data_author <- left_join(data_author, data_name_ending, by = 'name_ending')
data_author$label_ending <- data_author$label_ending %>% replace_na('U')

data_author$gender <- ifelse(data_author$label == 'U',
                             data_author$label_ending,
                             data_author$label)

# if author is unknown: set NA
data_author$gender <- ifelse(is.na(data_author$gname) |
                               nchar(data_author$gname) == 0,
                             NA,
                             data_author$gender)

data_author$label <- ifelse(is.na(data_author$gname) |
                              nchar(data_author$gname) == 0,
                            NA,
                            data_author$label)

# overview
table(data_author$gender)

# factor
labels <- factor(data_author$gender)

labels_full_name <- factor(data_author$label)

labels_ending <- factor(data_author$label_ending)

# accuracy
p <- data_author$p
p_ending <- data_author$p_ending

# save data
saveRDS(data_author, 'data/author/tidy_author_data/data_author_names.rds')

rm(data_name)
rm(data_name_ending)

# read data
data_author <- readRDS('data/author/tidy_author_data/data_author.rds')

# labeling and accuracy
data_author$label <- labels
data_author$label_full_name <- labels_full_name
data_author$label_ending <- labels_ending
data_author$p <- p
data_author$p_ending <- p_ending

data_author <- data_author %>%
  # # create reasonable numeric publication date variables
  mutate(pub.print.year = as.numeric(substr(published.print, 1, 4)),
         pub.print.month = as.numeric(substr(published.print, 6, 7)),
         pub.online.year = as.numeric(substr(published.online, 1, 4)),
         pub.online.month = as.numeric(substr(published.online, 6, 7))) %>%
  select(-c(published.print, published.online))

# add coding for unknown years
data_author$year <- ifelse(
  ifelse(is.na(data_author$pub.online.year),
         9999,
         data_author$pub.online.year) <
    ifelse(is.na(data_author$pub.print.year),
           9999,
           data_author$pub.print.year),
  data_author$pub.online.year,
  data_author$pub.print.year
)

# save final data set after naive bayes classification
saveRDS(data_author,
        'data/author/tidy_author_data/data_author_naive_bayes.rds')

# overview
table(data_author$label)
table(data_author$label_full_name)
