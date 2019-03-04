##   Project Piecemeal
##   A.Chafetz | USAID
##   Purpose: breakout COP19 targets & budget for ETAP to compile workplans
##   Date: 2019.03.04
##   Updated:

# DEPENDENCIES ------------------------------------------------------------
  library(tidyverse)
  library(openxlsx)

# TARGETS - DATA PACK -----------------------------------------------------

  #build consolidated file
    #see GitHub - USAID-OHA-SI/tameDP

  #import targets
    df_dp <-
      read_tsv("RawData/COP19_DataPack_Consolidated_20190301.txt",
               col_types = cols(.default = "c")) %>%
      mutate(fy2020_targets = as.double(fy2020_targets))

  #keep just USAID
    df_dp <- filter(df_dp, fundingagency == "USAID")

  #create total numerators (remove KeyPop)
    df_output_dp <- df_dp %>%
      filter(!is.na(indicator),
             str_detect(disaggregate, "KeyPop", negate = TRUE))

  #kp prev filtered out since it only has a KeyPop disagg
    df_kpprev <- df_dp %>%
      filter(indicator == "KP_PREV")

  #add KP_PREV in and create total numerator
    df_output_dp <- df_dp %>%
      bind_rows(df_kpprev) %>%
      group_by(operatingunit, #psnu, psnuuid,
               mechanismid, primepartner, implementingmechanismname,
               indicator = paste0(indicator, " (", numeratordenom, ")")) %>%
      summarise_at(vars(fy2020_targets), sum, na.rm = TRUE) %>%
      ungroup()


# BUDGET TARGETS - FAST ---------------------------------------------------

  #build consolidated file
    #see GitHub - USAID-OHA-SI/fastR

  #import FAST
    df_fast <-
      read_csv("RawData/COP19_FAST_Consolidated_20190301v2.csv",
             col_types = cols(.default = "c")) %>%
      mutate(amt = as.double(amt))

  #keep just USAID
    df_fast <- filter(df_fast, fundingagency == "USAID")

  #collapse interventions and beneficiaries
    df_output_fast <- df_fast %>%
      filter(cop == "COP19",
             program != "CODB") %>%
      mutate(intervention = paste0(program,": ", programarea, " - ", servicedelivery) %>%
               str_remove_all("(ND|PM): | - (PM|ASP|ND)"),
             beneficiary = paste0(beneficiary, ": ", subbeneficiary) %>% str_replace("NA: NA", as.character(NA)))

  #create total
    df_output_fast <- df_output_fast %>%
      group_by(operatingunit,
               mechanismid, primepartner, implementingmechanismname = mechanismname,
               intervention, beneficiary) %>%
      summarise(cop19_budget = sum(amt, na.rm = TRUE))




# EXPORT TO EXCEL ---------------------------------------------------------

  #create a workbook
    wb <- createWorkbook("COP19")

  ## Add 2 worksheets
    addWorksheet(wb, "COP19 Targets")
    addWorksheet(wb, "COP19 Budget")

  #write data
    writeData(wb, sheet = "COP19 Targets", df_output_dp)
    writeData(wb, sheet = "COP19 Budget", df_output_fast)

  #format targets and budget
    s_k <- createStyle(numFmt = "#,##0")
    addStyle(wb, "COP19 Targets", style = s_k,
             rows = 2:nrow(df_output_dp),
             cols = ncol(df_output_dp),
             gridExpand = TRUE)

    s_d <- createStyle(numFmt = "$#,##0")
    addStyle(wb, "COP19 Budget", style = s_d,
             rows = 2:nrow(df_output_fast),
             cols = ncol(df_output_fast), gridExpand = TRUE)

  #adjust columns to auto width
    setColWidths(wb, sheet = "COP19 Targets",
                 cols = 1:ncol(df_output_dp),
                 widths = "auto")
    setColWidths(wb, sheet = "COP19 Budget",
                 cols = 1:ncol(df_output_fast),
                 widths = "auto")

  #export
    path <- paste0("Output/COP19_WorkPlan_TargetsAndBudget_", format(Sys.Date(), "%Y%m%d"), ".xlsx")
    saveWorkbook(wb, path, overwrite = TRUE)
