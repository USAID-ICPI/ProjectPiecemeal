ind_tabulate <- function(df, mech, ind){
  
  #filter to just the mechanism
    df_mech <- filter(df, mechanismid == !!mech)
    
  #filter for the indicator 
    if(ind != "SiteReporting"){
      df_mech <- filter(df_mech, indicator == !!ind)
    }
              
  #store for saving purposes
    ou <- df_mech$operatingunit[1]
  
  #setup table (wide)
    if(ind != "SiteReporting"){
      df_mech <- df_mech %>% 
        select(psnu, agesexother, fy2019_targets) %>% 
        spread(agesexother, fy2019_targets) %>% 
        rename(!!ind := psnu) #table name in upper left hand corner
    } else {
      df_mech <- df_mech %>% 
        select(-operatingunit, -mechanismid) %>% 
        spread(indicator, reporting) %>% 
        rename(!!ind := site) #table name in upper left hand corner
    }
  
  #export to Excel
    #create a new folder path if it doesn't already exist
      ou_filepath <- file.path("Output", paste0(ou, "_COP18-Targets"))
      
    #create a new folder for the OU if it doesn't already exist
      dir_create(ou_filepath)
                 
    #create file path to save  
      path <- file.path(ou_filepath, paste0(ou, "_COP18-Targets_Mech-", mech, ".xlsx"))
    
    #if the file doesn't exist add it otherwise, open it
      if(!file.exists(path)){
        wb <- createWorkbook()
      } else{
        wb <- loadWorkbook(path)
      }
    #create worksheet off indicator name
      addWorksheet(wb, ind)
    #write data
      writeData(wb, ind, df_mech)
    
    #identify table dimensions for formatting
      n_col <- ncol(df_mech)
      n_row <- as.integer(nrow(df_mech) + 1)
      m <- as.integer(max(n_col, n_row))
    
    #apply styles
      #indicator/sheet title
      addStyle(wb, ind, style_title, rows = 1, cols = 1)
      #headers  
      addStyle(wb, ind, style_headers, rows = 1, cols = 2:n_col)
      #psnus
      addStyle(wb, ind, style_psnus, rows = 2:n_row, cols = 1)
      #values
      if(ind != "SiteReporting"){
        addStyle(wb, ind, style_values, rows = 2:m, cols = 2:m, gridExpand = TRUE)
      } else {
        addStyle(wb, ind, style_reporting, rows = 2:m, cols = 2:m, gridExpand = TRUE)
      }
      
    #adjust width/height  
      if(ind != "SiteReporting"){
        w <- 20L
      } else {
        w <- 50L
      }
      #increase the width for the psnu column
      setColWidths(wb, ind, cols=1, widths = w)
      #increase the row height for the headers
      setRowHeights(wb, ind, rows = 1, heights = 30)
    #save
      saveWorkbook(wb, path, overwrite = T)
}