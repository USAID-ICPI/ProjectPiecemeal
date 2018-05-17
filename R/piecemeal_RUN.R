
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
  source("R/piecemeal_setup.R")
  setup(df_targets)
  
#break into pieces by IMs and indicators
  
  #TODO
  x <- df %>% 
    filter(mechanismuid == "18304",
           indicator == "HTS_TST_POS") %>% 
    spread(agesexother, fy2019_targets)
  