#### Function to use rtweet and perform searches ####
rtweet.save = function(file.path, terms, overwrite){
  library(rtweet)
  library(tidyverse)
  library(ggmap)
  
  if(missing(overwrite)){
    overwrite <- TRUE
  }
  
  ## Perform the search
  search.new <- rtweet::search_tweets2(
    terms, n = 500, include_rts = F) %>% 
    dplyr::select(user_id:source, place_name:country_code) %>%
    dplyr::distinct()
  
  ## Collect user lat and long data (if available)
  user_info <- rtweet::lookup_users(unique(search.new$user_id))
  
  discard(user_info$location, `==`, "") %>% 
    ggmap::geocode() -> coded
  
  coded$location <- discard(user_info$location, `==`, "")
  
  user_info <- dplyr::left_join(user_info, coded, "location")
  
  ## Merge lat/long data to tweets and overwrite the previous search 
  search.new = search.new %>%
    dplyr::left_join(user_info[, c("user_id", "lon", "lat")]) %>%
    dplyr::distinct()
  
  if(overwrite){
  ## Read in previous version of tweet data file
  search.prev <- read.csv(file.path, stringsAsFactors = F)
  
  ## Convert necessary column types and remove un-needed variables
  search.prev$created_at <- as.POSIXct(search.prev$created_at)
  search.prev$user_id <- as.character(search.prev$user_id)
  search.prev$status_id <- NULL
  
  ## Join previous searches to new search and save
  search.new = search.new %>%
    dplyr::left_join(search.prev) %>%
    dplyr::distinct()
  }
  
  write.csv(search.new, file = file.path, row.names = F)
}
