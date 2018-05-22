##   Project Piecemeal
##   A.Chafetz & J.Davis | USAID
##   Purpose: breakout COP18 targets by OU and IMxIndicator
##   Date: 2018.05.16
##   Updated: 2018.05.22


# DEPENDENCIES ------------------------------------------------------------

  #packages
    library(readxl)
    library(tidyverse)
    library(fs)

  #functions
    source("R/piecemeal_tidy.R")
    source("R/piecemeal_ou_export.R")
    source("R/piecemeal_im_setup.R")
    source("R/piecemeal_tabulate.R")

# IMPORT & MUNGE ----------------------------------------------------------

  #identify files [see RawData/README.md]
    files <- dir_ls("RawData", glob = "*.xlsx")
  
  #import & combine
    df_targets <- map_dfr(.x = files, .f = ~read_xlsx(.x))
  
  #clean up & format 
    df_targets <- tidy(df_targets)


# PHASE I - GENERIC OU FILES ----------------------------------------------

  #identify all OUs in df
    ou_list <- unique(df$operatingunit)
  
  #generate output for each export
    purrr::map(.x = ou_list, 
               .f = ~ ou_export(df_targets, .x))  
  
# PHASE II - IM TABLES - PSNU X INDICATOR  --------------------------------

  #setup IM output
    df_targets <- setup(df_targets)

  #list of mechs and indicators to loop over
    df_full <- df_targets %>% 
      distinct(mechanismuid, indicator)

  #generate output to export
    map2(.x = df_full$mechanismuid, .y = df_full$indicator, 
         .f = ~ tabulate(df_targets, .x, .y))
