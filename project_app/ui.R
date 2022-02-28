#remotes::install_github("RinteRface/fullPage")

# for hosting:
# setwd('/home/ubuntu/shiny_apps/210317/')

# load all global variables (theme, dicitonaries, ...), libraries, and
# functions
source('global_variables.R')

# load module data and functions
source('section_I_mod.R')
source('section_II_mod.R')
source('section_III_mod.R')
source('section_IV_mod.R')
source('section_V_mod.R')
source('section_VII_mod.R')
source('section_VIII_mod.R')

pagePiling(
  center = T,
  sections.color = c(theme$i_bg_color,
                     theme$ii_bg_color,
                     theme$iii_bg_color,
                     theme$iv_bg_color,
                     theme$v_bg_color,
                     theme$vii_bg_color,
                     theme$viii_bg_color),
  opts = options,
  menu = c("Home" = "home",
           "Data" = "data_overview",  # Data Overview
           "Gender Distribution" = "gender_distribution_overview",  # Gender Distribution Overview
           "Comparing Fields" = "comparing_fields",  # Comparing different Fields
           "Female-Male Ratio" = "female_male_ratio",
           "Journals and Impact Factors" = "journals_and_impact_factors",
           "About" = "about"),  # Project Information
  
  section_I_ui("section_I"),
  section_II_ui("section_II"),
  section_III_ui("section_III"),
  section_IV_ui("section_IV"),
  section_V_ui("section_V"),
  section_VII_ui("section_VII"),
  section_VIII_ui("section_VIII")
  
)