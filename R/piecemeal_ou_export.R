ou_export <- function(df, opunit){
  
  print(paste("export dataset:", opunit))
  filename <- 
    paste0("COP18_targets_USAID_", opunit,".csv") 
  
  df %>% 
    dplyr::filter(operatingunit == opunit) %>% 
    readr::write_csv(file.path("Output", filename), na = "")
  
  invisible(df)
}