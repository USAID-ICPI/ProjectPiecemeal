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
    library(openxlsx)

  #functions
    source("R/piecemeal_tidy.R")
    source("R/piecemeal_ou_export.R")
    source("R/piecemeal_im_setup.R")
    source("R/piecemeal_tabulate.R")
    source("R/piecemeal_styles.R")

# IMPORT & MUNGE ----------------------------------------------------------

  #identify files [see RawData/README.md]
    files <- dir_ls("RawData", glob = "*.xlsx")
  
  #import & combine
    df_targets <- map_dfr(.x = files, 
                          .f = ~read_xlsx(.x, col_types = "text"))
    rm(files)
  #clean up & format 
    df_targets <- tidy(df_targets)


# PHASE I - GENERIC OU FILES ----------------------------------------------

  #identify all OUs in df
    ou_list <- unique(df_targets$operatingunit)
  
  #generate output for each export
    map(.x = ou_list, 
        .f = ~ ou_export(df_targets, .x))  
  
# PHASE II - IM TABLES - PSNU X INDICATOR  --------------------------------

  #setup IM output
    df_targets_im <- setup(df_targets, "indicator")

  #list of mechs and indicators to loop over
    df_mechind <-  distinct(df_targets_im, operatingunit, mechanismid, indicator)

  #generate output to export
    map2(.x = df_mechind$mechanismid, .y = df_mechind$indicator, 
         .f = ~ ind_tabulate(df_targets_im, .x, .y))
      rm(df_targets_im, df_mechind)

# PHASE III - IMS BY SITE -------------------------------------------------

  #setup site reporting output
    df_sitereporting <- setup(df_targets, "site") 
  
  #list of mechs to loop over
    df_mech <- distinct(df_sitereporting, operatingunit, mechanismid)
    
  #generate output to export
    map(.x = df_mech$mechanismid, 
        .f = ~ ind_tabulate(df_sitereporting, .x, "SiteReporting"))
     rm(df_sitereporting, df_mech)

# ZIP FOLDERS -------------------------------------------------------------

  setwd("Output")
  folders <- dir_ls()
  map(.x = folders, .f = ~ zip(.x, .x))
  setwd("..")
    