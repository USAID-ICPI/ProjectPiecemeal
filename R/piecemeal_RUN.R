
library(readxl)
library(tidyverse)
library(fs)


#files
  files <- dir_ls("RawData", glob = "*.xlsx")

#import & combine
  df_targets <- map_dfr(.x = files, .f = ~read_xlsx(.x))

#run
  source("R/piecemeal_tidy.R")
  tidy(df_targets)
  