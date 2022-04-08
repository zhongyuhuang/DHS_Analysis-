# phase the PDF


#### Workspace setup ####
library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)

#download the pdf
download.file(
  "https://dhsprogram.com/pubs/pdf/FR103/FR103.pdf", 
  "Philippines_DHS1998.pdf",
  mode="wb")


# read the pdf
pdf_dhs <- pdf_text("Philippines_DHS1998.pdf")
pdf_dhs <- tibble(raw_data = pdf_dhs)


# grab the page that is of interest
dhs1 <- pdf_dhs %>% slice(70)


# separate the row and get rid of title and footnotes of the table
dhs2 <- dhs1 |> separate_rows(raw_data, sep = "\\n", convert = FALSE)
dhs3 <- dhs2 %>% slice(11:47)


#separate this into separate columns
dhs4 <- dhs3 %>% mutate(data = str_squish(raw_data)) %>% separate(col = raw_data, 
                  into = c("BG_inf", 
                           "PT_Mom", 
                           "PT_Pgt", 
                           "PT_bear", 
                           "NumOfTeen"), 
                  sep = "[[:space:]]{3,}", 
                  remove = FALSE
  )


# rewrite incorrect numbers and numbers that has ','
dhs4[10,6] = "1701"
dhs4[11,6] = "1223"
dhs4[17,5] = "10.6"
dhs4[32,3] = "17.3"
dhs4[34,6] = "1962"
dhs4[37,6] = "2924"



# make the numbers into actual numbers
options(digits=3)
dhs4$`25-29` <-as.numeric(dhs4$BG_inf)
dhs4$`30-34` <-as.numeric(dhs4$PT_Mom)
dhs4$`35-39` <-as.numeric(dhs4$PT_Pgt)
dhs4$`40-44` <-as.numeric(dhs4$PT_bear)
dhs4$`45-49` <-as.numeric(dhs4$NumOfTeen)


# save the output in outputs/data/raw_data.csv

write.csv(dhs4 , file = "outputs/data/raw_data.csv")




