# This script aims to provide an overview about the project structure
# DO NOT RUN

### data acquisition

  # CAUTION: The following script is computationally expensive
  source('scrape_crossref.R')

  source('scrape_impact_data.R')

### data cleaning and labeling (1st step)

  source('create_names_db.R')
  source('stack_author_data.R')
  
  # CAUTION: The following script is computationally expensive
  source('clean_author_data')

### labeling (2nd step)
  # CAUTION: The following script is computationally expensive
  # CAUTION: The following script may be monetary expensive
  source('unknown_names.R')

### data merging
  source('merge_author_impact.R')
  
### preparing app data
  source('prep_app_data_I.R')
  source('prep_app_data_II.R')
  source('prep_app_data_V_VII.R')
  source('prep_app_data_III_IV_prerequisition.R')
  source('prep_app_data_IV.R')
  source('prep_app_data_III.R')
  
### Extensions and plots for presentation
  source('sanity_check_threshold.R')
  source('cdf_figures.R')
  source('sanity_check_human_coder.R')
  source('sanity_check_source_comparison.R')
  
  # these scripts have to be adjusted
  source('presentation_figures.R')