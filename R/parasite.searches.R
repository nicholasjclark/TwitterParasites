#### Search Twitter for mentions of specific ectoparasites ####
library(rtweet)
library(tidyverse)

## Read in previous version of tweet data file
tick.search.prev <- read.csv('./searches/tick.search.csv',
                             stringsAsFactors = F)
tick.search.prev$created_at <- as.POSIXct(tick.search.prev$created_at)

## Update the search and overwrite the previous file
tick.search.new <- search_tweets2(
  c("paralysis tick OR ixodes OR tick paralysis", 
    "tick fever OR Babesia"),
  n = 500, include_rts = F
) %>% select(created_at:source,place_name:country_code) %>%
  left_join(tick.search.prev)

write.csv(tick.search.new, file = './searches/tick.search.csv',
          row.names = F)

#### Repeat for flea searches ####
flea.search.prev <- read.csv('./searches/flea.search.csv',
                             stringsAsFactors = F)
flea.search.prev$created_at <- as.POSIXct(flea.search.prev$created_at)

flea.search.new <- search_tweets2(
  c("cat flea OR dog flea OR ctenocephalides", 
    "rickettsia OR cat scratch fever"),
  n = 500, include_rts = F
) %>% select(created_at:source,place_name:country_code) %>%
  left_join(flea.search.prev)

write.csv(flea.search.new, file = './searches/flea.search.csv',
          row.names = F)

