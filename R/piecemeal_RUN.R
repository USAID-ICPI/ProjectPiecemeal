##   Project Piecemeal
##   A.Chafetz
##   Purpose: breakout COP18 targets by OU and IMxIndicator
##   Date: 2018.05.16
##   Updated: 2018.05.18


# DEPENDENCIES ------------------------------------------------------------

  library(readxl)
  library(tidyverse)
  library(fs)


# IMPORT & MUNGE ----------------------------------------------------------

  #files
    files <- dir_ls("RawData", glob = "*.xlsx")
  
  #import & combine
    df_targets <- map_dfr(.x = files, .f = ~read_xlsx(.x))
  
  #clean up & format 
    source("R/piecemeal_tidy.R")
    df_targets <- tidy(df_targets)


# TEIR I - GENERIC OU FILES -----------------------------------------------

  #identify all OUs in df
    ou_list <- unique(df$operatingunit)
    
  #gen Output folder if it doesn't already exist
    fs::dir_create("Output")
  
  #generate output for each export
    source("R/piecemeal_ou_export.R")
    purrr::map(.x = ou_list, .f = ~ ou_export(df_targets, .x))  
  

# TIER II - IM TABLES - PSNU X INDICATOR  ---------------------------------

  #setup IM output
    source("R/piecemeal_im_setup.R")
    df_targets <- setup(df_targets)

  #list of mechs and indicators to loop over
    df_full <- df_targets %>% 
      distinct(mechanismuid, indicator)

  #generate output
    source("R/piecemeal_tabulate.R")
    map2(.x = df_full$mechanismuid, .y = df_full$indicator, .f = ~ tabulate(df_targets, .x, .y))
  
  #export
    #TODO