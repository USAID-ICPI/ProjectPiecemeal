
library(readxl)
library(tidyverse)
library(fs)


#files
  files <- dir_ls("RawData", glob = "*.xlsx")

#import & combine
  df_targets <- map_dfr(.x = files, .f = ~read_xlsx(.x))

#run OU output
  source("R/piecemeal_tidy.R")
  tidy(df_targets)
  
#setup IM output
  source("R/piecemeal_im_setup.R")
  df_targets <- setup(df_targets)
  
#break into pieces by IMs and indicators
  mech_list <- unique(df_targets$mechanismuid)
  
  df_full <- df_targets %>% 
    distinct(mechanismuid, indicator)

  
  #TODO
  
  ind_tabulate <- function(df, mech, ind){
    df_mech <- df %>% 
      filter(mechanismuid == !!mech,
             indicator == !!ind) %>% 
      spread(agesexother, fy2019_targets)
    return(df_mech)
  }
  
  
  
  df_targets %>% 
    ind_tabulate( df_full$mechanismuid[1], df_full$indicator[1])
    
 
  