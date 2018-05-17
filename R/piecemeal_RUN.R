

#files
  file <- dir_ls("RawData", glob = "*.xlsx")

  df_grp1 <- read_xlsx("RawData/USAID_sitexIM_FY19Targets_B-S_5.16.18.xlsx")
  df_grp2 <- read_xlsx("RawData/USAID_sitexIM_FY19Targets_T-Z_5.16.18.xlsx")

#combine
  df_targets <- bind_rows(df_grp1, df_grp2)
  rm(df_grp1, df_grp2)

#run
  source("R/piecemeal_tidy.R")
  tidy(df_targets)
  