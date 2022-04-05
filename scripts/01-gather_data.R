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
dhs1 <- pdf_dhs %>% slice(69)


# separate the row and get rid of title and footnotes of the table
dhs2 <- dhs1 |> separate_rows(raw_data, sep = "\\n", convert = FALSE)
dhs3 <- dhs2 %>% slice(11:37)


#separate this into separate columns
dhs4 <- dhs3 %>% mutate(data = str_squish(raw_data)) %>% separate(col = raw_data, 
                  into = c("BG_inf", 
                           "25-29", 
                           "30-34", 
                           "35-39", 
                           "40-44", 
                           "45-49", 
                           "25-49"), 
                  sep = "[[:space:]]{2,}", 
                  remove = FALSE
  )


# rewrite numbers that has ','
dhs4[3,3] = "22.3"
dhs4[3,4] = "22.3"
dhs4[3,5] = "22.3"
dhs4[3,8] = "22.2"
dhs4[6,5] = "24.7"
dhs4[9,6] = "22.2"
dhs4[15,3] = "22.9"
dhs4[15,8] = "21.6"
dhs4[9,6] = "22.2"
dhs4[18,8] = "22.7"
dhs4[9,6] = "22.2"
dhs4[21,6] = "20.9"
dhs4[24,3] = "19.9"
dhs4[24,5] = "20.4"
dhs4[24,6] = "20.4"
dhs4[27,6] = "26.3"


# make the numbers into actual numbers
options(digits=3)
dhs4$`25-29` <-as.numeric(dhs4$`25-29`)
dhs4$`30-34` <-as.numeric(dhs4$`30-34`)
dhs4$`35-39` <-as.numeric(dhs4$`35-39`)
dhs4$`40-44` <-as.numeric(dhs4$`40-44`)
dhs4$`45-49` <-as.numeric(dhs4$`45-49`)
dhs4$`25-49` <-as.numeric(dhs4$`25-49`)

# save the output in outputs/data/raw_data.csv

write.csv(dhs4 , file = "outputs/data/raw_data.csv")




