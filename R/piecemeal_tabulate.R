ind_tabulate <- function(df, mech, ind){
  
  #store for saving purposes
  ou <- df$operatingunit[1]
  mechid <- df$mechanismuid[1]
  
  #gen table
  df_mech <- df %>% 
    filter(mechanismuid == !!mech,
           indicator == !!ind) %>%
    select(psnu, agesexother, fy2019_targets) %>% 
    spread(agesexother, fy2019_targets) %>% 
    rename(!!ind := psnu) #table name in upper left hand corner
  
  return(df_mech)
  
  #TODO export to Excel
    #use indicator as tab name
    #save name COP18_targets_ou_mechid.xlsx

}