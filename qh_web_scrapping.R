#read web page
library(rvest)

url <- "https://www.qld.gov.au/health/conditions/health-alerts/coronavirus-covid-19/current-status/contact-tracing"

html_document <- read_html(url)

html_document

str(html_document)

df <- html_document %>% 
  rvest::html_nodes('table') %>% 
  .[-4] %>% 
  html_table (fill = T) %>% 
  lapply(., function(x) setNames(x, c("Date", "Place", "Suburb", 
                                      "Arrival_time", "Departure_time")))

df_2 <- bind_rows (df)

tofind <- paste(c("NSW","Vic", "SA", "WA", "ACT", "NT", "TAS", "Brisbane"), collapse = "|")

df_3 <- df_2 %>% 
   mutate (State = as.character (str_extract_all (Suburb, tofind)),
           State = ifelse (State == "character(0)", "Not stated", State),
           State = ifelse (State == "Brisbane", "QLD", State))

#numbe r of exposure sites per state
df_3 %>% 
  count (State)



