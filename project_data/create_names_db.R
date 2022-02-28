# This Script produces labeled data sets for specific name characteristics

rm(list = ls())

library(dplyr)
library(tidyr)
###############################

###############################################################################
####  PART I  #################################################################
###############################################################################

# This PART I creates a F-M-labelled data set for full names

# define and assign new column names
cols <- c('name', 'gender', 'frequency', 'include')

# read in data set 2
names_db2 <- read.csv('data/name/raw_name_data/names_gender.csv')

# assign new column names
colnames(names_db2) <- cols[1:3]

# recode characters
names_db2$name <- iconv(names_db2$name,
                        from = 'UTF-8',
                        to = 'ASCII//TRANSLIT')

# merge contained names of both data sets
names1 <- unique(names_db2$name)
names_db2_male <- names_db2 %>% filter(gender == 'M')
names_db2_female <- names_db2 %>% filter(gender == 'F')

# join additional information
names_db1 <- left_join(data.frame(name = names1),
                       names_db2_male, by = c('name'))
names_db1 <- left_join(names_db1,
                       names_db2_female, by = c('name'))

# replace produced NAs by 0 for computational reasons
names_db1$frequency.x <- replace_na(names_db1$frequency.x, 0)
names_db1$frequency.y <- replace_na(names_db1$frequency.y, 0)

# compute total frequency
names_db1 <- names_db1 %>%
  select(name,
         frequency_male = frequency.x,
         frequency_female = frequency.y)

n_male <- sum(names_db1$frequency_male)
n_female <- sum(names_db1$frequency_female)

# calculate probabilities for naive bayes
p_male <- sum(names_db1$frequency_male) /
  (sum(names_db1$frequency_male) + sum(names_db1$frequency_female))

p_female <- sum(names_db1$frequency_female) /
  (sum(names_db1$frequency_male) + sum(names_db1$frequency_female))

names_db1 <- names_db1 %>%
  mutate(p_name_male = frequency_male / n_male,
         p_name_female = frequency_female / n_female,
         p_name = (frequency_male + frequency_female) / (n_male + n_female),
         p_male_name = p_male * (p_name_male / p_name),
         p_female_name = p_female * (p_name_female / p_name))

# assign labels based on probability
names_db1$label <- NA
names_db1$label <- ifelse(names_db1$p_male_name > .5, 'M', 'F')
names_db1$label <- ifelse(
  (names_db1$p_male_name >= .4) & (names_db1$p_male_name <= .6),
  'D',
  names_db1$label)

# accuracy
names_db1$p <- apply(cbind(names_db1$p_male_name, names_db1$p_female_name),
                     1,
                     max)

### save data
names_db_final <- names_db1
saveRDS(names_db_final, file = 'data/name/tidy_name_data/names_db.rds')

###############################################################################
#### PART II  #################################################################
###############################################################################

# This PART II creates a labelled F-M-dataset for name endings (3 characters)

# copy original dataset and drop D-observations
names_ending <- filter(names_db_final, label != 'D')

# extract name endings: last 3 characters of each name
names_ending$name_ending <- substr(names_ending$name,
                                   nchar(names_ending$name) - 2,
                                   nchar(names_ending$name))

# select relevant columns
names_ending <- select(names_ending,
                       name_ending, frequency_male, frequency_female)

# define groups in data structure
names_ending <- group_by(names_ending, name_ending)

# calculate group-wise accuracy mean and number of ending occurrences for
# naive bayes
names_ending <- summarise_all(names_ending, list(sum))

n_male <- sum(names_ending$frequency_male)
n_female <- sum(names_ending$frequency_female)

p_male <- sum(names_ending$frequency_male) /
  (sum(names_ending$frequency_male) + sum(names_ending$frequency_female))

p_female <- sum(names_ending$frequency_female) /
  (sum(names_ending$frequency_male) + sum(names_ending$frequency_female))

names_ending <- names_ending %>%
  mutate(p_name_male = frequency_male / n_male,
         p_name_female = frequency_female / n_female,
         p_name = (frequency_male + frequency_female) / (n_male + n_female),
         p_male_name = p_male * (p_name_male / p_name),
         p_female_name = p_female * (p_name_female / p_name))

# assign labels based on probabilities
names_ending$label <- NA
names_ending$label <- ifelse(names_ending$p_male_name > .5, 'M', 'F')
names_ending$label <- ifelse(
  (names_ending$p_male_name >= .4) & (names_ending$p_male_name <= .6),
  'D',
  names_ending$label)

# accuracy
names_ending$p <- apply(
  cbind(names_ending$p_male_name, names_ending$p_female_name),
  1,
  max)


### save data
saveRDS(names_ending, file = 'data/name/tidy_name_data/names_ending.Rds')
