
# configure workspace
source("config/config.R")


#################################
###   Webscrapping: tables    ###
#################################

#----------------------- 1. Read html page 

# COVID-19 case counts and testing 
data <- read_html("data/covid_html.html")
data

#----------------------- 2. Scrape all tables

# (0) Scrape all tables
tables <-
  data %>%
  html_table(fill = T)


#----------------------- 3. Scrape Table 1
# 4th and 5th tables are for 
# Table 1 on the webpage 

# inspect 4th table
dim(tables[[4]])
tables[[4]]

# save 4th table: 
# remove first 3 rows
# and last 1 row 
table_by_people_1 <- 
  tables[[4]][-c(1:3, 9), ]

# inspect 5th table
dim(tables[[5]])
head(tables[[5]], 10)
tail(tables[[5]], 10)

# save 5th table:
table_by_people_2 <- 
  tables[[5]]

# save Table 1 
# merge 4th & 5th tables from "tables"
table_by_people <- 
  rbind(table_by_people_1,
        table_by_people_2)

# define var names
var_name <- 
  unlist(c(
    tables[[4]][2, ][1],
    tables[[4]][2, ][2],
    tables[[4]][2, ][3],
    tables[[4]][2, ][4],
    tables[[4]][2, ][5]
  ))

# add var names 
names(table_by_people) <- var_name

# format var names
table_by_people <-
  table_by_people %>%
  clean_names()

# see data 
dim(table_by_people)
data.table(head(table_by_people,4))

# save data 
write.table(table_by_people, 
            "cache/table_by_people.txt", 
            sep = "\t",
            row.names = F)

#----------------------- 4. Scrape Table 2

# 6th and 7th tables are for 
# Table 1 on the webpage 

# inspect 6th table
dim(tables[[6]])
data.table(tables[[6]])

# save 6th table: 
# remove first 3 rows
# and last 1 row 
table_by_school_1 <- 
  tables[[6]][-c(1:3, 9), ]

# inspect 7th table
dim(tables[[7]])
data.table(head(tables[[7]], 10))
data.table(tail(tables[[7]], 10))

# save 7th table:
table_by_school_2 <- 
  tables[[7]]

# save Table 2
# merge 6th & 7th tables from "tables"
table_by_school <- 
  rbind(table_by_school_1,
        table_by_school_2)

# define var names
var_name2 <- 
  unlist(c(
       tables[[6]][2, ][1],
       tables[[6]][2, ][2],
       tables[[6]][2, ][3],
       tables[[6]][2, ][4],
       tables[[6]][2, ][5],
       tables[[6]][2, ][6]
  ))

# add var names 
names(table_by_school) <- var_name2

# format var names
table_by_school <-
  table_by_school %>%
  clean_names()

# see data 
dim(table_by_school)
data.table(head(table_by_school,4))

# save data 
write.table(table_by_school, 
            "cache/table_by_school.txt", 
            sep = "\t",
            row.names = F)












