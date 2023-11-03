


# configure workspace
source("config/config.R")

#----------------------- load data 

# table 1
table_by_people <- 
  read.delim("cache/table_by_people.txt")

# table 2
table_by_school <- 
  read.delim("cache/table_by_school.txt")

#----------------------- Data clean

# convert week to "Year + Week Number"

# Table 1 
table_by_people$week_format <- 
  as.Date(table_by_people$week)

# Table 2
table_by_school$week_format <- 
  as.Date(table_by_school$week)



###########################
### OC Covid Case Plot  ###
###########################

#----------------------- Plots Table 1
# (a) Table 1: confirmed cases plot

# define colors 
my_colors <- c("Student" = "#63b5cc", 
               "Teacher" = "#315b94", 
               "Other Staff" = "#7c9dad", 
               "Grand Total" = "#b3b0a0")

# figure 1
p1 <- ggplot(table_by_people, 
       aes(week_format)) +
  geom_line(aes(y = student, 
                colour = "Student")) +
  geom_line(aes(y = teacher, 
                colour = "Teacher")) +
  geom_line(aes(y = other_staff, 
                colour = "Other Staff")) +
  geom_line(aes(y = grand_total, 
                colour = "Grand Total")) +
  labs(colour = "Cases",
       caption = "Source: OC Health Care Agency") + 
  xlab("Week") +
  ylab("Total Cases") +
  ggtitle("Figure 1-Schools:",
          subtitle = "All COVID-19 Cases by Students, Teachers, and Other Staff") +
  scale_x_date(date_labels = '%m/%e/%y',
               breaks = '4 week') +
  scale_color_manual(values = my_colors) + 
  
  # add horizontal line
  geom_hline(
    yintercept = c(1000, 2000, 3000, 4000), 
    linetype = "solid", 
    color = "gray", 
    size = 0.2) + 
  theme

# save plot
ggsave("figure/fig1_table_by_people.png",
       p1,
       dpi=1000)

#----------------------- Plot Table 2
# (a) Table 2: confirmed cases plot

# define colors 
my_colors <- c("Elementary/Middle" = "#63b5cc", 
               "High School" = "#315b94", 
               "Combined (k-12)" = "#7c9dad", 
               "College/University/Vocational" = "#b3b0a0",
               "Grand Total" = "#d6c254")

# plot
p2 <- ggplot(table_by_school, 
       aes(week_format)) +
  geom_line(aes(y = elementary_middle, 
                colour = "Elementary/Middle")) +
  geom_line(aes(y = high_school, 
                colour = "High School")) +
  geom_line(aes(y = combined_k_12, 
                colour = "Combined (k-12)")) +
  geom_line(aes(y = college_university_vocational, 
                colour = "College/University/Vocational")) +
  geom_line(aes(y = grand_total, 
                colour = "Grand Total")) +
  labs(colour = "Cases",
       caption = "Source: OC Health Care Agency") + 
  xlab("Week") +
  ylab("Total Cases") +
  ggtitle("Figure 2-Schools:",
          subtitle = "All COVID-19 Cases by School Type") +
  scale_x_date(date_labels = '%m/%e/%y',
               breaks = '4 week') +
  scale_color_manual(values = my_colors) + 
  # add horizontal line
  geom_hline(
    yintercept = c(1000, 2000, 3000, 4000), 
    linetype = "solid", 
    color = "gray", 
    size = 0.2) + 
  theme

# save plot
ggsave("figure/fig2_table_by_school.png",
       p2,
       dpi=1000)
