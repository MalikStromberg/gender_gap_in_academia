# install packages
if (!require("remotes")) install.packages("remotes")
if (!require("shiny")) install.packages("shiny")
if (!require("formattable")) install.packages("formattable")
if (!require("plotly")) install.packages("plotly")
if (!require("shinyWidgets")) install.packages("shinyWidgets")
if (!require("plyr")) install.packages("plyr")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("cowplot")) install.packages("cowplot")
if (!require("extrafont")) install.packages("extrafont")
if (!require("gridExtra")) install.packages("gridExtra")
# remotes::install_github("hrbrmstr/waffle") # entkommentieren für die Abgabe
if (!require("fullPage")) remotes::install_github("RinteRface/fullPage")

# load libraries
library(shiny)
library(plotly)
library(shinyWidgets)
library(fullPage)
library(tidyverse)
library(extrafont)
library(cowplot)
library(gridExtra)
library(waffle)

# load global functions
source('functions/f_get_fields.R')
source('functions/f_create_numerics.R')
source('functions/f_app_theme.R')
source('functions/f_create_html_table.R')

# initialize global variables
theme <- app_theme('gender_app')

dictionary <- get_fields(T)
names(dictionary) <- get_fields(F) %>%
  str_replace_all('and', '&') %>%
  str_replace_all('Human Resource', 'HR') %>%
  str_replace_all('miscellaneous', 'misc.')

dictionary <- dictionary[order(dictionary)]

# extended dictionary: 'all fields'
dictionary_ext <- 'all_fields' %>% append(dictionary)
names(dictionary_ext) <- 'All Fields' %>% append(names(dictionary))

dictionary_reverse <- get_fields(F) %>%
  str_replace_all('and', '&') %>%
  str_replace_all('Human Resource', 'HR') %>%
  str_replace_all('miscellaneous', 'misc.')
dictionary_reverse <- dictionary_reverse[order(dictionary_reverse)]

names(dictionary_reverse) <- get_fields(T)

options <- list(touchSensitivity = 80,
                easing = 'linear',
                scrollingSpeed = 500)