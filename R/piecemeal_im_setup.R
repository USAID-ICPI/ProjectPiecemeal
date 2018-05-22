
setup <- function(df){

  df <- df %>% 
    mutate(indicator = ifelse(numeratordenom == "D", paste0(indicator, "_D"), indicator),
           disaggregate = ifelse((indicator == "HTS_TST" & disaggregate != "KeyPop/Result" & !is.na(disaggregate)), 
                                 "Age/Sex/Result/Modality", disaggregate),
           otherdisaggregate = ifelse(indicator == "PMTCT_STAT" & otherdisaggregate == "NewPregnant",
                                      paste(otherdisaggregate, ": ", resultstatus), otherdisaggregate),
           mechanismid = as.character(mechanismid))
  
  
  df_hts_pos <- df %>% 
    filter(indicator == "HTS_TST", disaggregate == "Age/Sex/Result/Modality", resultstatus == "Positive") %>% 
    mutate(indicator = "HTS_TST_POS")
  
  df <- bind_rows(df, df_hts_pos)
    
  rm(df_hts_pos)
  
  tokeep <- 
    tibble::tribble(
         ~indicator,                             ~disaggregate, ~keep,
          "HTS_TST",                 "Age/Sex/Result/Modality",   "Y",
      "HTS_TST_POS",                 "Age/Sex/Result/Modality",   "Y",
           "TX_NEW",                       "Age/Sex/HIVStatus",   "Y",
          "TX_CURR",                       "Age/Sex/HIVStatus",   "Y",
           "TX_RET",            "Age Aggregated/Sex/HIVStatus",   "Y",
        "TX_PVLS_D", "Age Aggregated/Sex/Indication/HIVStatus",   "Y",
         "OVC_SERV",                                 "Age/Sex",   "Y",
      "OVC_HIVSTAT",                                        NA,   "Y",
       "PMTCT_STAT",                  "Age/Sex/KnownNewResult",   "Y",
        "PMTCT_ART",            "NewExistingArt/Sex/HIVStatus",   "Y",
        "PMTCT_EID",                                     "Age",   "Y",
          "PP_PREV",                                 "Age/Sex",   "Y",
          "KP_PREV",                                  "KeyPop",   "Y",
        "VMMC_CIRC",                                 "Age/Sex",   "Y",
         "PrEP_NEW",                                 "Age/Sex",   "Y",
          "TB_STAT",                      "Age Aggregated/Sex",   "Y",
           "TB_ART",            "Age Aggregated/Sex/HIVStatus",   "Y",
          "TB_PREV",            "Age Aggregated/Sex/HIVStatus",   "Y",
          "TX_TB_D",            "Age Aggregated/Sex/HIVStatus",   "Y",
         "GEND_GBV",                     "ViolenceServiceType",   "Y",
         "HTS_SELF",                     "Age/Sex/HIVSelfTest",   "Y"
      )
  
  df <- inner_join(df, tokeep, by = c("indicator", "disaggregate"))
  
  rm(tokeep)
  
  df <- df  %>% 
    mutate(agesexother = case_when(
                      indicator %in% c("GEND_GBV", "KP_PREV", "PMTCT_ART", "PMTCT_STAT") ~ otherdisaggregate,
                      indicator == "OVC_HIVSTAT"                                         ~ "Total Numerator",
                      indicator == "PMTCT_EID"                                           ~ age, 
                      TRUE                                                               ~ paste(sex, age)
    ))
  
  
  df <- df %>% 
    select(-c(facility, fundingagency, numeratordenom, numeratordenom, age, sex, resultstatus, modality, disaggregate, otherdisaggregate, keep)) %>% 
    group_by_if(is.character) %>% 
    summarise_at(vars(fy2019_targets), ~ sum(., na.rm = TRUE)) %>% 
    ungroup()
  
  ordered <- c("Unknown Sex <1", "<= 2 months", "Male < 2 months", "2 - 12 months", "Male 2 months - 9 years", "Unknown Sex 1-9", "Female 1-9", 
               "Unknown Sex <5","Female 10-14", "Male 10-14", "Female <15", "Male <15", "Female 15+", "Male 15+", "Female 15-19", 
               "Male 15-19", "Female 15-17", "Male 15-17", "Female 18-24", "Male 18-24", "Female 20-24", "Male 20-24", "Female 25+", 
               "Male 25+", "Female 25-29", "Male 25-29", "Female 30-34", "Male 30-34", "Female 35-39", "Male 35-39", "Female 40-49", 
               "Male 40-49", "Female 50+", "Male 50+", "Female Unknown Age", "Male Unknown Age", "AlreadyPregnant", "NewPregnant", 
               "KnownPregnant", "NewPregnant :  Negative", "NewPregnant :  Positive", "FSW", "MSM not SW", "MSM SW", 
               "People in prisons and other enclosed settings", "PWID", "TG not SW", "TG SW", 
               "Physical and/or Emotional Violence", "Sexual Violence (Post-Rape Care)", "Total Numerator")
  
  df <- df %>% 
    mutate(agesexother = factor(agesexother, levels = ordered))
  
  #reorder
    df <- df %>% 
      select(operatingunit, indicator, mechanismid, primepartner, implementingmechanismname, psnu, agesexother, fy2019_targets)
    
}


  

