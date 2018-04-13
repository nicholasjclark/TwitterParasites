#### Search Twitter for mentions of specific ectoparasites ####
setwd("~/Google Drive/Academic Work Folder/TwitterParasites")
source('./functions/twitter.functions.R')

## Carry out tick searches and save the file
rtweet.save(file.path = './searches/tick.search.csv',
            terms = c("paralysis tick",
                      "tick paralysis",
                      "ixodes",
                      "dog tick",
                      "dog paralysis tick",
                      "#tickseason",
                      "removing ticks",
                      "tick infestation",
                      "tick prevention"),
            overwrite = TRUE)

## Repeat for flea searches
rtweet.save(file.path = './searches/flea.search.csv',
            terms = c("cat flea", 
                      "dog flea", 
                      "ctenocephalides", 
                      "removing fleas", 
                      "flea infestation", 
                      "flea prevention"),
            overwrite = TRUE)

#### Repeat searches using Google trends data ####
source('./functions/gtrends.functions.R')
gtrends.save(file.path = './searches/tick.gtrends.search.csv', 
             region = 'global', 
             terms = list(c("paralysis tick", 
                            "tick paralysis",
                            "ixodes", 
                            "dog tick",
                            "dog paralysis tick"),
                          c("removing ticks",
                            "tick infestation", 
                            "tick prevention")),
             overwrite = TRUE)

# Perform Australian (QLD and NSW) regional searches
gtrends.save(file.path = './searches/tick.gtrends.au.search.csv', 
             region = "Australia",
             terms = list(c("paralysis tick", 
                            "tick paralysis",
                            "ixodes", 
                            "dog tick",
                            "dog paralysis tick"),
                          c("removing ticks",
                            "tick infestation", 
                            "tick prevention")),
             overwrite = TRUE)

#### Repeat for flea gtrends searches ####
gtrends.save(file.path = './searches/flea.gtrends.search.csv', 
             region = "global",
             terms = list(c("cat flea", "dog flea", "ctenocephalides", 
                            "removing fleas", "flea infestation"), 
                          c("flea prevention")),
             overwrite = TRUE)

gtrends.save(file.path = './searches/flea.gtrends.au.search.csv', 
             region = "Australia",
             terms = list(c("cat flea", "dog flea", "ctenocephalides", 
                            "removing fleas", "flea infestation"), 
                          c("flea prevention")),
             overwrite = TRUE)
