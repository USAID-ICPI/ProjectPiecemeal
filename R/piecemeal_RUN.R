##   Project Piecemeal
##   A.Chafetz
##   Purpose: breakout COP18 targets by OU and IMxIndicator
##   Date: 2018.05.16
##   Updated: 2018.05.18

#dependencies
  library(readxl)
  library(tidyverse)
  library(fs)

#files
  files <- dir_ls("RawData", glob = "*.xlsx")

#import & combine
  df_targets <- map_dfr(.x = files, .f = ~read_xlsx(.x))

#run OU output (split tidy dataframes)
  source("R/piecemeal_tidy.R")
  tidy(df_targets)
  
#setup IM output
  source("R/piecemeal_im_setup.R")
  df_targets <- setup(df_targets)

#list of mechs and indicators to loop over
  df_full <- df_targets %>% 
    distinct(mechanismuid, indicator)

#generate output
  source("R/piecemeal_tabulate.R")
  map2(.x = df_full$mechanismuid, .y = df_full$indicator, .f = ~ tabulate(df_targets, .x, .y))