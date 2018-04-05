#### Function to add start and end dates to weekly gtrends searches
add.dates.gtrends = function(x){
  # Get today's date and the date from a week ago
  today.date <- as.POSIXlt(Sys.Date())
  week.ago.date <- today.date
  week.ago.date$mday <- week.ago.date$mday - 7
  
  # Add start and end dates to input dataframe
  trends <- x
  trends$end.date <- today.date
  trends$start.date <- week.ago.date
  return(trends)
}

#### Function to perform weekly gtrends searches and add dates ####
gtrends.search = function(terms, region){
  library(tidyverse)
  
  if(missing(region)){
    region <- 'global'
  }
  
  if(region == 'global'){
    trends <- gtrendsR::gtrends(terms, gprop = "web", 
                                time = "now 7-d")$interest_by_country
    trends.dated <- add.dates.gtrends(trends)
    
  } else {
    trends <- gtrendsR::gtrends(terms, geo = region, 
                                time = "now 7-d")$interest_by_city
    trends = trends %>%
      dplyr::group_by(location, keyword, geo, gprop) %>%
      dplyr::mutate(total.hits = sum(hits, na.rm = T)) %>%
      dplyr::ungroup() %>%
      dplyr::select(-hits) %>%
      dplyr::distinct()
    
    trends.dated <- add.dates.gtrends(trends)
  }
  return(trends.dated)
}

#### Function gtrends.save to overwrite previous gtrends search and save ####
gtrends.save = function(file.path, region, terms, overwrite){
  
  if(missing(overwrite)){
    overwrite <- TRUE
  }
  
  if(!region %in% c('global','Australia')){
    stop('Region must be either "global" or "Australia"')
  }
  
  if(region == 'global'){
    # !Only five search terms can be retrieved at a time, so 
    # need to perform two separate searches here! #
    trends.new <- rbind(gtrends.search(terms = terms[[1]]),
                        gtrends.search(terms = terms[[2]]))
    
  } else {
    # If not performing global search, use Australian states as regions
    trends.new.qld <- rbind(gtrends.search(terms = terms[[1]],
                                           region = "AU-QLD"),
                            gtrends.search(terms = terms[[2]],
                                           region = "AU-QLD"))
    trends.new.nsw <- rbind(gtrends.search(terms = terms[[1]],
                                           region = "AU-NSW"),
                            gtrends.search(terms = terms[[2]],
                                           region = "AU-NSW"))
    
    trends.new <- rbind(trends.new.qld, trends.new.nsw)
  }
  
  if(overwrite){
  #Read the previous search file
  trends.prev <- read.csv(file.path)
  
  #Convert dates to POSIXlt format
  trends.prev$start.date <- as.POSIXlt(trends.prev$start.date)
  trends.prev$end.date <- as.POSIXlt(trends.prev$end.date)
  
  #Overwrite the previous search file
  trends.new <- rbind(trends.new, trends.prev)
  }
  write.csv(trends.new, file = file.path, row.names = F)
}