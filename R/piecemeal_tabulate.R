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
    #create file path to save  
      path <- file.path("Output", paste0(ou, "_COP18-Targets_Mech-", mech, ".xlsx"))
    
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
      addStyle(wb, ind, style_values, rows = 2:m, cols = 2:m, gridExpand = TRUE)
      
    #adjust width/height  
      #increase the width for the psnu column
      setColWidths(wb, ind, cols=1, widths = 20)
      #increase the row height for the headers
      setRowHeights(wb, ind, rows = 1, heights = 30)
    #save
      saveWorkbook(wb, path, overwrite = T)
    
    #print to determine "location"
    paste0(ou, ": ", mech, " - ", ind)
}