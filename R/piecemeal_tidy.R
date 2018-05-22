

tidy <- function(df){
  
  #change value from string to double
    df <- df %>% 
      mutate(value = as.double(value))
    
  #rename headers to match MER structured datasets
    df <- df %>% 
      rename(operatingunit = OU,
           facility = organisation_unit_name,
           fundingagency = funding_agency,
           primepartner = prime_partner_name,
           mechanismid = mechanism_code,
           implementingmechanismname = implementing_mechanism_name,
           resultStatus = HIVStatus,
           fy2019_targets = value
           ) %>% 
      rename_all(~tolower(.))
  
  #combine columns into one to match MER Structured Dataset
    df <- df %>% 
      unite("otherdisaggregate", c("keypop", "knownnewstatus", "newexistingart", "indication", 
                                   "tbstatus", "pregbf", "vmmctechnique", "otherdisagg"), 
            sep = "", remove = TRUE) %>% 
      #remove NA's from unite
      mutate(otherdisaggregate = str_remove_all(otherdisaggregate,"NA"))
  
  #limit to just relevent columns
    df <- df %>% 
      select(operatingunit:disaggregate, age, sex, resultstatus, modality, otherdisaggregate, fy2019_targets)
  
    return(df)
}



