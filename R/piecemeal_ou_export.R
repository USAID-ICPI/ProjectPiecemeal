ou_export <- function(df, opunit){
  
  print(paste("export dataset:", opunit))
  filename <- paste0("COP18_targets_USAID_", opunit,".csv") 
  
  #create a new folder path if it doesn't already exist
  ou_filepath <- file.path("Output", paste0(ou, "_COP18-Targets"))
  
  #create a new folder for the OU if it doesn't already exist
  dir_create(ou_filepath)
  
  df %>% 
    dplyr::filter(operatingunit == opunit) %>% 
    readr::write_csv(file.path(ou_filepath, filename), na = "")
  
  invisible(df)
}