


# configure workspace
source("config/config.R")

#--------------- 1. load & clean data 

# load data 
table_by_people <- 
  read.delim("cache/table_by_people.txt")

# convert week to "Year + Week Number"
table_by_people$week_format <- 
  as.Date(table_by_people$week)

# subset data: only need grand total cases
table_by_people_sub <- select(table_by_people,
                              grand_total,
                              week_format)


#########################
###    Loess model    ###
#########################

#--------------- 1. Use loess model to predict
#  covid cases (to smooth out cases during US
# holidays - Thanksgiving and Christmas)

# order data 
table_by_people_sub <- 
  table_by_people_sub %>% 
  arrange(week_format)

# lowess model
lowess <- 
  lowess(
    table_by_people_sub$week_format, 
    table_by_people_sub$grand_total, 
    f = 0.4)

# create vector: holiday
holiday <- 
  as.Date(
    c("2020-11-22", 
      "2020-11-29",
      "2020-12-20",
      "2020-12-27",
      "2021-11-21",
      "2021-11-28",
      "2021-12-19",
      "2021-12-26"))

# get positions of the holiday in data 
holiday_position <- which(table_by_people_sub$week_format %in% holiday) 

# extract predicted cases during holiday
holiday_cases <- 
  data.frame(
    "Holiday Week" = holiday,
    "Recorded Cases" = 
      c(table_by_people_sub$grand_total[c(holiday_position)]),
    "Predicted Cases" = 
      c(lowess$y[c(holiday_position)])
  )

# save data 
write.table(holiday_cases,
            "cache/holiday_cases.txt", 
            sep = "\t",
            row.names = F)

###############################
###    Plot Predicted Cases ###
###############################

#--------------- 1. Plot recorded vs predicted data

# set up covid waves 
table_by_people_sub <-
  table_by_people_sub %>% 
  mutate(covid_wave = case_when(
    (week_format >= as.Date("2020-08-16") &
       week_format <= as.Date("2021-05-23")) ~ 
      "Original",
    (week_format >= as.Date("2021-05-23") &
       week_format <= as.Date("2021-11-14")) ~ 
      "Delta",
    (week_format >= as.Date("2021-11-14")) ~ 
      "Omicron"))

# (1) plot 1: separate by waves

# define colors
my_colors <- c("Original" = "#63b5cc", 
               "Delta" = "#315b94", 
               "Omicron" = "#7c9dad")
# plot 
p3 <- ggplot(data = table_by_people_sub,
       aes(x = week_format,
           y = grand_total)) + 
  geom_line(color = "gray",
             size = 0.5) + 
  geom_smooth(aes(colour = covid_wave),
              method = "loess", 
              span = 0.4, 
              se = F,
              size = 0.8
              ) + 
  scale_x_date(date_labels = '%m/%e/%y',
               breaks = '4 week') + 
  labs(colour = "Covid Wave",
       caption = "Source: OC Health Care Agency") + 
  xlab("Week") +
  ylab("Total Cases") +
  ggtitle("Using LOESS Model to Predict Each Covid Variant",
          subtitle = "Recorded vs Predicted Data") +
  scale_color_manual(values = my_colors) + 
  geom_vline(xintercept = 
               as.Date(c("2020-11-22",
                         "2020-12-20",
                         "2021-11-21",
                         "2021-12-19")), 
             linetype = "dotted", 
             color = "gray", 
             size = 0.3) +
  theme(legend.position = c(0.5, 0.6)) + 
  annotate(geom = "text",
           label = 
             c(as.character("2020 Thanksgiving"), 
               as.character("2020 Christmas"),
               as.character("2021 Thanksgiving"), 
               as.character("2021 Christmas")),
           x = as.Date(c("2020-11-15",
                         "2020-12-27",
                         "2021-11-14",
                         "2021-12-26")),
           y = c(1200, 2000, 3300, 4000),
           angle = 0, 
           vjust = 1,
           color = "gray48",
           size = 2) + 
  theme 

# save plot 
ggsave("figure/fig3_loess_separate.png",
       p3,
       dpi=1000)

# (2) plot 2: all waves in one curve

# define colors 
my_colors <- c("Recorded Cases" = "gray", 
               "Predicted Cases" = "red")

# plot 
ggplot(data = table_by_people_sub,
       aes(x = week_format,
           y = grand_total)) + 
  geom_line(aes(colour = "Recorded Cases"),
            size = 0.5) + 
  geom_smooth(aes(colour = "Predicted Cases"),
              method = "loess", 
              span = 0.2, 
              se = F,
              size = 0.6
  ) + 
  scale_x_date(date_labels = '%m/%e/%y',
               breaks = '4 week') + 
  labs(colour = "Data Type",
       caption = "Source: OC Health Care Agency") + 
  xlab("Week") +
  ylab("Total Cases") +
  ggtitle("Using LOESS Model to Predict Each Covid Variant",
          subtitle = "Recorded vs Predicted Data") +
  scale_color_manual(values = my_colors) + 

  # add horizontal line
  geom_hline(
    yintercept = c(1000, 2000, 3000, 4000), 
    linetype = "solid", 
    color = "gray", 
    size = 0.2) + 
  
  # add vertical line
  geom_vline(xintercept = 
               as.Date(c("2020-11-22",
                         "2020-12-20",
                         "2021-11-21",
                         "2021-12-19")), 
             linetype = "dotted", 
             color = "gray", 
             size = 0.3) +
  
  # annotate vertical lines
  annotate(geom = "text",
           label = 
             c(as.character("2020 Thanksgiving"), 
               as.character("2020 Christmas"),
               as.character("2021 Thanksgiving"), 
               as.character("2021 Christmas")),
           x = as.Date(c("2020-11-15",
                         "2020-12-27",
                         "2021-11-14",
                         "2021-12-26")),
           y = c(1200, 2000, 3300, 4000),
           angle = 0, 
           vjust = 1,
           color = "gray48",
           size = 2) + 
  theme 


# save plot 
ggsave("figure/fig4_loess_all.png",
       p4,
       dpi=1000)