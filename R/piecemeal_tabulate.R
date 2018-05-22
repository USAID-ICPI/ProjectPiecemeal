ind_tabulate <- function(df, mech, ind){
  
  #store for saving purposes
  ou <- df$operatingunit[1]
  
  #gen table
  df_mech <- df %>% 
    filter(mechanismid == !!mech,
           indicator == !!ind) %>%
    select(psnu, agesexother, fy2019_targets) %>% 
    spread(agesexother, fy2019_targets) %>% 
    rename(!!ind := psnu) #table name in upper left hand corner
  
  #export to Excel
    #print to determine "location"
    return(paste0(ou, ": ", mech, " - ", ind))
    
    #create file path to save  
    path <- file.path("Output", paste0(ou, "_COP18-Targets_Mech-", mech, ".xlsx"))
    
    #if the file doesn't exist add it otherwise, open it
    if(!dir.exists(path)){
      wb <- createWorkbook()
    } else{
      wb <- loadWorkbook(path)
    }
    addWorksheet(wb, ind)
    writeData(wb, ind, df_mech)
    saveWorkbook(wb, path, overwrite = T)  

}